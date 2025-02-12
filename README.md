```markdown
# Recon Scan Script

This Bash script performs a series of reconnaissance tasks on a list of domains. For each domain in your list, it:

- Performs a **WHOIS** lookup.
- Runs **NSLOOKUP**.
- Executes **traceroute**.
- Runs **theHarvester** to gather additional subdomain, IP, and email information.
- Executes **dnsrecon** to gather DNS-related data.

The results for each domain are saved into a dedicated folder under a specified results directory.

## Prerequisites

Before running the script, make sure you have the following tools installed on your system:

- **whois**  
- **nslookup** (usually provided by `dnsutils`)
- **traceroute**
- **theHarvester**  
- **jq** (for processing JSON)
- **dnsrecon**

### Installing Dependencies on Debian/Ubuntu

You can install most prerequisites via `apt-get`:

```bash
sudo apt-get update
sudo apt-get install whois dnsutils traceroute jq dnsrecon
```

For **theHarvester**, you can install it using `pip`:

```bash
pip install theHarvester
```

*Note: If you are using a different operating system, please refer to your package manager or the official project pages for installation instructions.*

## Installation

1. **Download or Clone the Repository**

   If you have a repository, clone it:
   
   ```bash
   git clone https://github.com/yourusername/recon-scan.git
   cd recon-scan
   ```

   Otherwise, simply download the `recon_scan.sh` script.

2. **Prepare the Domains File**

   Create a file containing one domain per line. By default, the script expects the file to be located at:

   ```
   /home/<yourusername>/Documents/Assets/Domains/domains.txt
   ```

   If your domains file is elsewhere, update the `domains_file` variable at the top of the script.

3. **Make the Script Executable**

   In your terminal, run:

   ```bash
   chmod +x recon_scan.sh
   ```

## Usage

Simply run the script from your terminal:

```bash
./recon_scan.sh
```

The script will:
- Iterate over each domain in your domains file.
- Create a new folder for each domain under the results directory (`/home/<yourusername>/Documents/Assets/Scan/Results` by default).
- Save the outputs of the following commands:
  - `whois` results in `whois.txt`
  - `nslookup` results in `nslookup.txt`
  - `traceroute` results in `traceroute.txt`
  - **theHarvester** JSON output in `theharvester_results.json`, along with processed subdomains (`harvester_subdomains.txt`), IPs (`ips.txt`), and emails (`emails.txt`)
  - `dnsrecon` output in `dnsrecon_std_results.json`

## Customization

- **Domains File:**  
  Change the `domains_file` variable at the top of the script if your list is stored in a different location.

- **Results Directory:**  
  Modify the `parent_directory` variable to set a different directory for your scan results.

- **Additional Tools:**  
  The variables for `resolvers_file` and `wordlist_file` are defined but not used by default. You can integrate these into the script if needed.

## Troubleshooting

- **Domains File Not Found:**  
  If you see an error stating that the domains file cannot be found, verify that the file exists at the specified location and that the path is correct.

- **Permission Issues:**  
  Ensure you have sufficient permissions to read the input files and write to the output directories.

- **Missing Commands:**  
  If any of the commands (e.g., `theHarvester`, `jq`, etc.) are not found, ensure they are installed and accessible in your system's PATH.

## Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue or submit a pull request if you have suggestions or improvements.

## License

This project is licensed under the [MIT License](LICENSE).

```

---

### How to Use This README

1. **Place this file** in the same directory as your script or in the root of your project repository as `README.md`.
2. **Update any paths or repository links** (like the GitHub URL) to match your setup.
3. **Commit and share** the file along with your script so others can easily understand how to set up and use your recon scan script.
