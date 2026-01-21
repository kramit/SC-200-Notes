# Open TAXII Servers and Threat Intelligence Sources

## Overview
TAXII (Trusted Automated eXchange of Indicator Information) is a standardized protocol for exchanging threat intelligence. This document provides a comprehensive list of publicly accessible TAXII servers and threat intelligence sources that can be integrated with Microsoft Sentinel and other SIEM platforms.

---

## TAXII Protocol Versions
- **TAXII 2.0** - Earlier version with core functionality
- **TAXII 2.1** - Current standard with enhanced features and improved compatibility

---

## Public TAXII Servers and Threat Intelligence Sources

### 1. **AlienVault OTX (Open Threat Exchange)**
- **Organization**: AT&T Cybersecurity (AlienVault)
- **Type**: Community-driven threat intelligence platform
- **URL**: https://otx.alienvault.com/
- **Data Types**: 
  - IP addresses
  - File hashes
  - URLs
  - Domain names
  - CVEs
- **Access**: Free with registration
- **TAXII Support**: Yes (TAXII 2.0/2.1 compatible)
- **Description**: One of the largest open threat intelligence communities with millions of threat indicators contributed by security researchers worldwide

### 2. **abuse.ch Threat Intelligence Platforms**
- **Organization**: abuse.ch (Institute for Cybersecurity and Engineering at Bern University)
- **Partnership**: Spamhaus

#### **MalwareBazaar**
- **URL**: https://bazaar.abuse.ch/
- **Focus**: Newly observed malware samples
- **Data**: Malware binaries, hashes, metadata
- **TAXII Support**: Available
- **Access**: Free

#### **URLhaus**
- **URL**: https://urlhaus.abuse.ch/
- **Focus**: Malicious URLs used for malware distribution
- **Data**: URLs, hosting information, associated malware
- **TAXII Support**: Available
- **Access**: Free

#### **ThreatFox**
- **URL**: https://threatfox.abuse.ch/
- **Focus**: Indicators of Compromise (IOCs)
- **Data**: IOCs associated with malware campaigns
- **TAXII Support**: Available
- **Access**: Free

#### **SSL Blacklist (SSLBL)**
- **URL**: https://sslbl.abuse.ch/
- **Focus**: Malicious SSL certificates
- **Data**: Certificate hashes, JA3/JA3S fingerprints
- **TAXII Support**: Available
- **Access**: Free

#### **YARAify**
- **URL**: https://yaraify.abuse.ch/
- **Focus**: YARA rules repository
- **Data**: YARA detection rules for malware identification
- **TAXII Support**: Available
- **Access**: Free

#### **Feodo Tracker**
- **URL**: https://feodotracker.abuse.ch/
- **Focus**: Command and Control (C2) tracking
- **Data**: C2 server addresses, bot information
- **TAXII Support**: Available
- **Access**: Free
- **Note**: Dataset currently empty following Operation Endgame

#### **Hunting Platform**
- **URL**: https://hunting.abuse.ch/
- **Focus**: Unified threat intelligence search
- **Data**: Search across all abuse.ch platforms with single query
- **Supports**: IPv4, domains, URLs, file hashes
- **TAXII Support**: Available
- **Access**: Free

### 3. **Anomali ThreatStream**
- **Organization**: Anomali
- **Type**: Commercial threat intelligence platform with free/community tiers
- **URL**: https://www.threatstream.com/
- **Data Types**:
  - Malware intelligence
  - APT tracking
  - Threat actor profiles
  - Campaign intelligence
- **TAXII Support**: Yes (TAXII 2.0/2.1 compatible)
- **Integrations**: Works with Microsoft Sentinel, Splunk, ServiceNow, and 50+ other platforms
- **Features**:
  - AI-driven threat analysis
  - Enriched indicator context
  - Custom tagging and confidence ratings

### 4. **FS-ISAC (Financial Services Information Sharing and Analysis Center)**
- **Organization**: Financial services sector ISACs
- **Type**: Sector-specific threat intelligence
- **Membership**: Primarily for financial institutions
- **TAXII Support**: Yes (TAXII 2.0/2.1)
- **Special Requirements**: IP allowlisting required for Microsoft Sentinel (see IP allowlist below)
- **Data Types**:
  - Financial sector-specific threats
  - Fraud indicators
  - Incident information

### 5. **CISA Threat Intelligence**
- **Organization**: Cybersecurity and Infrastructure Security Agency (US)
- **Type**: Government threat intelligence
- **URL**: https://www.cisa.gov/
- **Data Types**:
  - Known Exploited Vulnerabilities
  - Malware analysis
  - APT intelligence
- **TAXII Support**: Yes, available through AIS (Automated Indicator Sharing)
- **Access**: Available to US government and critical infrastructure

### 6. **MISP (Malware Information Sharing Platform)**
- **Type**: Open-source TAXII server
- **URL**: https://www.misp-project.org/
- **Deployment**: Self-hosted community instances available
- **TAXII Support**: Yes (TAXII 2.0/2.1)
- **Community Instances**:
  - Multiple public MISP instances operated by organizations and communities
  - searchable at https://www.misp-project.org/

### 7. **Shodan**
- **Organization**: Shodan
- **Type**: Internet-connected device intelligence
- **URL**: https://www.shodan.io/
- **Data Types**:
  - Exposed services
  - Vulnerable systems
  - Infrastructure data
- **TAXII Support**: Available through API
- **Access**: Free tier with limited results, Premium available

### 8. **Meta Threat Exchange**
- **Organization**: Meta (Facebook)
- **Type**: Social media threat intelligence
- **Data Types**:
  - Malware hashes
  - Phishing URLs
  - Suspicious domains
- **TAXII Support**: Yes
- **Access**: Limited, requires authorization

### 9. **Spamhaus**
- **Organization**: Spamhaus
- **Type**: Email and network threat intelligence
- **URL**: https://www.spamhaus.org/
- **Data Types**:
  - IP blacklists (PBL, SBL, CBL)
  - Domain blacklists
  - Botnet intelligence
- **TAXII Support**: Available through partner integrations
- **Access**: Free and commercial tiers

### 10. **VirusTotal Intelligence**
- **Organization**: Alphabet/Google-owned
- **Type**: File and URL analysis
- **URL**: https://www.virustotal.com/
- **Data Types**:
  - File hashes
  - File analysis results
  - URL analysis
- **TAXII Support**: Available through API
- **Access**: Free tier and Premium intelligence

---

## Microsoft Sentinel IP Allowlisting

### For TAXII Import Connector
When connecting to TAXII servers (especially FS-ISAC) that require IP allowlisting, use these Microsoft Sentinel TAXII client IP addresses:

**US East Region:**
- 20.193.17.32
- 20.197.219.106
- 20.48.128.36
- 20.199.186.58
- 40.80.86.109
- 52.158.170.36

**US West Region:**
- 20.52.212.85
- 52.251.70.29
- 20.74.12.78
- 20.194.150.139
- 20.194.17.254
- 51.13.75.153

**Europe Region:**
- 102.133.139.160
- 20.197.113.87
- 40.123.207.43
- 51.11.168.197
- 20.71.8.176
- 40.64.106.65

### For TAXII Export Connector
IP addresses for exporting threat intelligence from Microsoft Sentinel:

**Regional IPs** (Multiple regions):
- 68.218.134.151
- 4.237.173.121
- 68.218.191.192
- 68.218.191.208
- 74.163.73.85
- 74.163.73.84
- 108.140.47.197
- 108.140.47.196
- 130.107.0.17
- 130.107.0.16
- 52.242.47.153
- 52.242.47.152
- 4.186.93.129
- 4.186.93.128
- 57.158.18.39
- 57.158.18.38
- 128.203.32.17
- 20.232.93.192
- 128.24.7.173
- 128.24.7.172
- 4.251.60.81
- 4.251.60.80
- 20.111.81.65
- 20.111.81.64
- 20.218.50.5
- 20.218.50.4
- 72.144.227.117
- 72.144.227.116
- 51.4.37.231
- 20.217.163.215
- 72.146.91.160
- 4.232.40.176
- 74.176.2.247
- 74.176.2.246
- 74.226.38.228
- 4.190.136.176
- 4.181.55.53
- 4.181.55.52
- 20.200.167.49
- 20.200.167.48
- 4.207.244.69
- 132.164.237.192
- 4.235.51.87
- 4.235.51.86
- 51.120.182.208
- 4.220.173.230
- 4.171.25.225
- 4.171.25.224
- 4.253.54.45
- 4.253.54.44
- 172.209.40.109
- 172.209.40.108
- 172.188.182.119
- 172.188.182.118
- 20.207.217.212
- 74.224.83.8
- 135.225.179.229
- 135.225.179.228
- 20.91.127.183
- 20.91.127.182
- 4.226.56.22
- 74.242.228.97
- 74.242.60.137
- 74.242.4.65
- 74.243.66.228
- 74.243.66.227
- 74.243.225.230
- 74.243.225.229
- 74.177.108.204
- 172.187.102.73
- 51.142.135.18
- 51.142.135.17
- 50.85.238.240
- 132.220.84.130
- 172.184.49.127
- 172.184.49.126
- 4.149.254.64
- 172.179.34.64

---

## Integration with Microsoft Sentinel

### Prerequisites
1. Microsoft Sentinel Contributor role at resource group level
2. TAXII 2.0 or 2.1 server API root URI
3. Collection ID for the threat intelligence feed
4. Optional: Username and password (if required by TAXII server)

### Configuration Steps
1. Install the **Threat Intelligence** solution from Content Hub
2. Select **Data connectors** > **Threat Intelligence - TAXII**
3. Enter:
   - Friendly name
   - API root URL
   - Collection ID
   - Username (if required)
   - Password (if required)
4. Choose indicator groups and polling frequency
5. Select **Add** to establish connection

### Export Configuration
1. Select **Threat intelligence - TAXII Export** data connector
2. Configure:
   - Friendly name
   - API root URL
   - Collection ID
   - Authentication type (Basic or API key)
3. Optionally enable rules for exported indicators
4. Select **Add** to start exporting

---

## Best Practices for TAXII Integration

1. **Start with Multiple Sources**: Combine data from abuse.ch, OTX, and sector-specific feeds for comprehensive coverage
2. **Validate Indicators**: Cross-reference indicators across multiple sources before acting on them
3. **Set Appropriate Polling Frequency**: Balance between data freshness and API rate limits
4. **Monitor Collection Health**: Track connector health and alert on failures
5. **Use Confidence Ratings**: Prioritize high-confidence indicators from established sources
6. **Implement Automation**: Create detection rules based on TAXII threat intelligence
7. **Regular Review**: Periodically audit and optimize which feeds provide the most value
8. **Document Sources**: Maintain records of source credibility and data coverage for compliance

---

## Data Types Commonly Available

| Data Type | Description | Common Sources |
|-----------|-------------|-----------------|
| **IP Addresses** | Malicious or suspicious IPs | OTX, abuse.ch, FS-ISAC |
| **Domain Names** | Command & Control, phishing domains | OTX, abuse.ch, Spamhaus |
| **File Hashes** | MD5, SHA1, SHA256 hashes | MalwareBazaar, OTX, VirusTotal |
| **URLs** | Phishing, malware distribution URLs | URLhaus, OTX, abuse.ch |
| **Email Addresses** | Associated with threats | Various community sources |
| **CVE IDs** | Vulnerability information | CISA, OTX |
| **File Behaviors** | YARA rules, malware analysis | YARAify, OTX |
| **SSL Certificates** | Malicious certificates | SSLBL, various sources |

---

## Troubleshooting

### Connection Issues
- Verify API root URL is correct and accessible
- Confirm Collection ID exists and is active
- Check IP allowlisting if required by TAXII server
- Verify credentials (username/password) if required

### Data Ingestion Issues
- Confirm polling frequency isn't too aggressive (check API rate limits)
- Review connector health status
- Check workspace capacity for threat intelligence
- Verify indicators meet Sentinel format requirements

### Performance Issues
- Consider splitting large feeds into multiple collection subscriptions
- Adjust polling frequency based on needs
- Monitor workspace ingestion rates
- Implement indicator filtering or classification rules

---

## Additional Resources

- [OASIS TAXII Specifications](https://oasis-open.github.io/cti-documentation/)
- [STIX 2.1 Specification](https://docs.oasis-open.org/cti/stix/v2.1/os/stix-v2.1-os.pdf)
- [Microsoft Sentinel Threat Intelligence Documentation](https://learn.microsoft.com/en-us/azure/sentinel/understand-threat-intelligence)
- [MITRE ATT&CK Framework](https://attack.mitre.org/)

---

*Last Updated: January 21, 2026*
*Source: OASIS, Microsoft Learn, and threat intelligence platform documentation*
