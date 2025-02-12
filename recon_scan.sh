#!/bin/bash

# Set the path to the domains file
domains_file="/home/stingray/Documents/Assets/Domains/domains.txt"

# Check if the domains file exists
if [ ! -f "$domains_file" ]; then
    echo "Error: Domains file not found: $domains_file"
    exit 1
fi

# Set the path to the resolvers file (currently not used in this script)
resolvers_file="/home/stingray/Documents/Assets/Resolvers/resolvers_trusted.txt"

# Set the path to the wordlist file (currently not used in this script)
wordlist_file="/home/stingray/Documents/Assets/Wordlists/subdomains-top1mil-5000.txt"

# Set the path to the results directory
parent_directory="/home/stingray/Documents/Assets/Scan/Results"

# Create the parent directory if it doesn't exist
mkdir -p "$parent_directory"

# Iterate over the domains in the file
while IFS= read -r domain || [ -n "$domain" ]; do
    # Skip empty lines
    [ -z "$domain" ] && continue

    # Create a new folder for the scan results for this domain
    scan_folder="${parent_directory}/${domain} Scan"
    mkdir -p "$scan_folder"

    # WHOIS lookup
    echo "Running whois on $domain"
    whois "$domain" > "$scan_folder/whois.txt"

    # NSLOOKUP
    echo "Running nslookup on $domain"
    nslookup "$domain" > "$scan_folder/nslookup.txt"

    # TRACEROUTE
    echo "Running traceroute on $domain"
    traceroute "$domain" > "$scan_folder/traceroute.txt"

    # theHarvester scan
    echo "Running theHarvester on $domain"
    theHarvester -f "$scan_folder/theharvester_results.json" \
                 -b baidu,bevigil,bing,bingapi,certspotter,crtsh,dnsdumpster,duckduckgo,hackertarget,otx,threatminer,urlscan,yahoo \
                 -l 500 -d "$domain"

    # Check if theHarvester generated a results file before processing it
    if [ -f "$scan_folder/theharvester_results.json" ]; then
        # Extract hostnames from theHarvester results
        jq -r '.hosts[]' "$scan_folder/theharvester_results.json" | sort -u | tee "$scan_folder/harvester_subdomains.txt"
        
        # Extract IPs from theHarvester results
        jq -r '.ips[]' "$scan_folder/theharvester_results.json" | sort -u | tee "$scan_folder/ips.txt"
        
        # Extract emails from theHarvester results
        jq -r '.emails[]' "$scan_folder/theharvester_results.json" | sort -u | tee "$scan_folder/emails.txt"
    else
        echo "Warning: theHarvester results file not found for $domain"
    fi

    # dnsrecon scan
    echo "Running dnsrecon on $domain"
    dnsrecon -t std --json "$scan_folder/dnsrecon_std_results.json" -d "$domain"

done < "$domains_file"
