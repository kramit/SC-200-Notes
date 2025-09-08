# Module 4 – Mitigate threats using Microsoft Defender for Endpoint (MDE)

## Overview
**Microsoft Defender for Endpoint (MDE)** helps prevent, detect, investigate, and respond to advanced endpoint threats. In SC-200 Learning Path 4 you configure onboarding, RBAC and device groups, harden Windows with Attack Surface Reduction (ASR) and related features, investigate devices and entities, tune detections, manage indicators (IoCs), integrate with Intune/Conditional Access to block risky devices, and use Defender Vulnerability Management (TVM) for continuous risk reduction.  
_Data retention note:_ MDE data is retained for **180 days**; Advanced Hunting queries typically access **~30 days** of raw device data. :contentReference[oaicite:0]{index=0}

---

## Onboarding & Service Configuration
**What it covers**
- **Service location** selection (not changeable later), **preview features** toggle, and onboarding entry points from the Defender portal. :contentReference[oaicite:1]{index=1}  
- **Supported platforms:** Windows, macOS, Linux, Android, iOS. Onboarding is guided with the right tooling (Intune/ConfigMgr/scripts/MDM). :contentReference[oaicite:2]{index=2}

**How it works**
- Selecting any **Endpoints** feature in the Defender portal kicks off onboarding steps and prerequisites. Device sensors stream telemetry to MDE/XDR for analytics and correlation. :contentReference[oaicite:3]{index=3}

**Setup essentials**
- Choose tenant **data location**, enable or disable **preview features**, then **onboard devices** per OS using your chosen management plane. Validate devices appear in the inventory with sensor healthy. :contentReference[oaicite:4]{index=4}

---

## Access Control (Unified RBAC) & Device Groups
**What it covers**
- **Unified RBAC** in Defender XDR for granular permissions (view data, remediation actions, live response, alerts investigation, posture settings). :contentReference[oaicite:5]{index=5}  
- **Device groups** to scope visibility and actions, set **automated remediation levels**, and map **Entra ID groups** for access. :contentReference[oaicite:6]{index=6}

**How it works**
- Create **custom roles** (e.g., Security Operator with Live Response) and assign to **device groups** (e.g., Servers, VIP endpoints). This controls who can act on which machines and what automation level applies. :contentReference[oaicite:7]{index=7}

**Setup essentials**
- Define device-group **matching rules** (name/domain/tags/OS), set **automation level** per group (Full/Semi/None), and map to **Entra ID** user groups. Rank groups to resolve overlaps. :contentReference[oaicite:8]{index=8}

---

## Windows Security Enhancements & ASR
**What it covers**
- **Attack surface reduction (ASR) rules**, **hardware-based isolation**, **application control**, **exploit protection**, **network protection**, **Windows Defender Firewall**, **web protection**, **controlled folder access**, **removable storage protection**. :contentReference[oaicite:9]{index=9}  
- ASR **sample rules** (e.g., block Office child processes, obfuscated scripts, ransomware protections). **Modes**: Off(0), Block(1), Audit(2), Warn(6). **Deployment** via Intune, ConfigMgr, GPO, MDM, or PowerShell. :contentReference[oaicite:10]{index=10}

**How it works**
- ASR applies granular **behavioral controls** to common attack vectors (Office macro abuse, script misuse). Other Windows protections reduce exploitability, restrict untrusted code, and limit data exfil paths. :contentReference[oaicite:11]{index=11}

**Setup essentials**
- Choose baseline policies per device group; start in **Audit/Warn** to measure impact, then **Block**. Use Intune security baselines where appropriate. :contentReference[oaicite:12]{index=12}

---

## Device Queue & Investigation
**What it covers**
- **Device queue** (defaults to devices with alerts in the last 30 days). **Investigate device** and **behavioral blocking/containment** options. :contentReference[oaicite:13]{index=13}  
- **Device actions**: manage tags, start **Automated Investigation**, open **Live Response**, collect **Investigation package**, run AV scans, restrict app execution, **isolate/contain** device, consult threat experts, and audit in **Action center**. :contentReference[oaicite:14]{index=14}  
- **Investigation package** contents include autoruns, installed apps, network connections, prefetch, processes, tasks, event logs, services, SMB sessions, system info, temp dirs, users/groups, WdSupportLogs. :contentReference[oaicite:15]{index=15}  
- **Live Response** remote shell with basic/advanced commands (e.g., `connections`, `fileinfo`, `registry`, `analyze`, `getfile`, `remediate`). :contentReference[oaicite:16]{index=16}

**How it works**
- From a device page, pivot across **timeline**, **alerts**, and **evidence**; initiate live response or AIR, then track actions and results centrally. :contentReference[oaicite:17]{index=17}

**Setup essentials**
- Ensure RBAC grants **Live Response** and **active remediation** rights; verify network reachability for isolation scenarios; define **automation levels** per device group. :contentReference[oaicite:18]{index=18}

---

## Evidence & Entities Investigation (Files, Domains/IPs, Users)
**What it covers**
- Investigate **files** for malicious indicators and scope.  
- Investigate **users** (e.g., “Users at risk”, lateral movement). :contentReference[oaicite:19]{index=19}  
- Investigate **IP addresses** (global info, reverse DNS, related alerts, org prevalence). :contentReference[oaicite:20]{index=20}  
- Investigate **domains/URLs** (registrant info, Microsoft verdicts, related incidents, prevalence, recent devices). :contentReference[oaicite:21]{index=21}

**How it works**
- Each entity page aggregates global reputation, org prevalence, related alerts/incidents, and cross-references to speed scoping and containment. :contentReference[oaicite:22]{index=22}

---

## Automation (AIR) & Content Analysis
**What it covers**
- **Advanced features** for automation: **File Content Analysis** (auto-upload files for deeper inspection) and **Memory Content Analysis** (inspect process memory during Automated investigations). :contentReference[oaicite:23]{index=23}  
- **Manage upload & folder settings** (define what folders, extensions, or filenames to **skip** during automated investigations). :contentReference[oaicite:24]{index=24}  
- **AIR automation levels**: **Full**, **Semi** (with variants), **None**. :contentReference[oaicite:25]{index=25}

**How it works**
- AIR expands scope, gathers artefacts, and performs remediation per **device-group automation level**; uploads are governed by your content analysis/skip policies. :contentReference[oaicite:26]{index=26}

**Setup essentials**
- Set **automation level** per device group; enable content analysis as required; configure **skip lists** for sensitive paths or tools to avoid false positives. :contentReference[oaicite:27]{index=27}

---

## Alert Settings, Notifications & Tuning
**What it covers**
- Configure **alert settings** and **email notifications** to keep responders informed. :contentReference[oaicite:28]{index=28}  
- **Alert tuning** via suppression rules for known-benign tools/processes, choosing **contexts** carefully to reduce noise without hiding risk. :contentReference[oaicite:29]{index=29}

**How it works**
- Tuning rules apply conditions (process path, hash, device group, etc.) to suppress or restrict alerts while preserving auditability in the incident timeline. :contentReference[oaicite:30]{index=30}

---

## Indicators (IoCs)
**What it covers**
- Manage **indicators of compromise** (files/URLs/IPs/certs) for detection and **blocking** (prevention & response). IoC matching is core to endpoint protection. :contentReference[oaicite:31]{index=31}

**How it works**
- Indicators flow into the sensor and cloud analytics; matches can trigger alerts or enforcement depending on policy. :contentReference[oaicite:32]{index=32}

---

## Device Discovery & Unmanaged Devices
**What it covers**
- Discover on-prem devices, assess risk, and **onboard unmanaged** endpoints. Queue defaults show devices with alerts seen in last **30 days**. :contentReference[oaicite:33]{index=33}

**How it works**
- Network and identity signals help surface unmanaged assets for inventory and onboarding. :contentReference[oaicite:34]{index=34}

---

## Intune Integration & Blocking At-Risk Devices
**What it covers**
- **Block at-risk devices** with Endpoint Manager (Intune) + Conditional Access. Steps:  
  1) Turn on **Intune connection** in Defender XDR.  
  2) Enable **MDE integration** in Endpoint Manager.  
  3) Create and assign **compliance** policy.  
  4) Create **Conditional Access** policy in Entra ID. :contentReference[oaicite:35]{index=35}

**How it works**
- Device risk feeds from MDE → Intune compliance → Conditional Access denies or restricts access until device is remediated. :contentReference[oaicite:36]{index=36}

---

## Defender Vulnerability Management (TVM)
**What it covers**
- Continuous risk assessment using **built-in/agentless** scanners—even for intermittently connected devices. Track **emerging threats**, prioritize **security recommendations**, and manage **remediation requests**. :contentReference[oaicite:37]{index=37}

**How it works**
- TVM maps software/assets to vulnerabilities and **exposure** metrics; you create remediation **requests**, track status, and verify closure. :contentReference[oaicite:38]{index=38}

---

## Lab (Learning Path 4)
- **Lab 01 – Mitigate threats using Microsoft Defender for Endpoint**: Deploy MDE and mitigate simulated attacks end-to-end. :contentReference[oaicite:39]{index=39}

---

## Quick Setup Checklist (Instructor)
- [ ] Select service **location**; toggle **preview** features. :contentReference[oaicite:40]{index=40}  
- [ ] **Onboard devices** by OS using Intune/ConfigMgr/scripts; verify inventory. :contentReference[oaicite:41]{index=41}  
- [ ] Configure **Unified RBAC** roles and **device groups** with automation levels. :contentReference[oaicite:42]{index=42}  
- [ ] Roll out **ASR & Windows protections** (audit → block). :contentReference[oaicite:43]{index=43}  
- [ ] Validate **device actions**, **investigation package**, and **live response**. :contentReference[oaicite:44]{index=44}  
- [ ] Enable **automation** features (file/memory analysis); set **skip lists**; choose **AIR** levels. :contentReference[oaicite:45]{index=45} :contentReference[oaicite:46]{index=46}  
- [ ] Configure **alert notifications** and **tuning**; define IoC workflows. :contentReference[oaicite:47]{index=47}  
- [ ] Integrate **Intune + Conditional Access** to block at-risk devices. :contentReference[oaicite:48]{index=48}  
- [ ] Review **TVM** dashboards; create remediation **requests**. :contentReference[oaicite:49]{index=49}

---

## Key Takeaways
- Success with MDE depends on **correct onboarding**, **RBAC/device groups**, and **calibrated automation**.  
- Combine **ASR/Windows protections** with **device investigations** and **IoC/alert tuning** to cut noise and speed response.  
- Integrate with **Intune/Conditional Access** for zero-trust enforcement and leverage **TVM** for continuous exposure reduction. :contentReference[oaicite:50]{index=50} :contentReference[oaicite:51]{index=51}
