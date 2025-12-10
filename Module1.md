# Module 1 – Mitigate Threats Using Microsoft Defender XDR

## Overview
Microsoft Defender XDR is Microsoft’s **extended detection and response (XDR)** platform that unifies telemetry and protections across **endpoints, identities, email & collaboration, SaaS/cloud apps, and IoT/OT**. It **correlates alerts into incidents**, enriching them with Microsoft threat intelligence and enabling **automation (SOAR)** to reduce dwell time and analyst workload.

**How it works:**  
Telemetry from Defender family products flows into the Defender XDR service. Analytics and graph correlations group related alerts (same user/device/IP/TTPs) into a **single incident**. Built-in **automatic attack disruption** and **automated investigation & remediation (AIR)** can contain threats (for example, isolate host, suspend account) while analysts validate actions in **Action centre**.

**Setup (at a glance):**
- **Licensing:** Microsoft 365 E5 (or equivalent licences that include Defender for Endpoint, Defender for Office 365, Defender for Identity, Defender for Cloud Apps) + Entra ID P2 for risk policies.
- **Access:** Use the Microsoft Defender portal `https://security.microsoft.com`.
- **RBAC:** Assign Entra ID roles (e.g., Security Reader/Operator/Administrator) and configure **Unified RBAC** in Defender XDR.
- **Onboarding:** Enable and connect each Defender product so telemetry and alerts sync into Defender XDR.

---

## Learning Objectives
- Understand Defender XDR by domain and its role in a modern SOC.  
- Apply the security operations model and incident lifecycle.  
- Investigate threats using the **Microsoft Security Graph API** and the portal.  
- Use **Advanced hunting (KQL)** to find, validate, and convert findings to detections.  
- Remediate risks across email, endpoints, identities, SaaS, and OT/IoT.

**Why this matters:**  
You’ll be able to **set up** the platform, **triage** and **investigate** incidents end-to-end, and **proactively hunt** for threats. The emphasis is on turning raw telemetry into **actionable detections** and **repeatable response**.

---

## Defender XDR in a Modern SOC
**What it does:**  
- **Unified portal & queue:** Single incident queue with correlated alerts.  
- **SOAR:** Automation rules and playbooks reduce repetitive work.  
- **Threat intel:** Detections enriched with Microsoft intelligence.  
- **Hunting & analytics:** KQL hunting over raw events; custom detections.  
- **Reporting & posture:** Threat analytics, Secure Score, exposure views.

**How it works:**  
Defender XDR models entities (users/devices/apps/hosts) and relationships in a **security graph**. Incidents aggregate evidence, timelines, and affected assets, giving analysts a cohesive “attack story”.

**Setup requirements:**  
- Ensure each workload (Endpoint, O365, Identity, Cloud Apps, IoT/OT) is **onboarded**.  
- Configure **email notifications**, **automation levels**, **device groups**, and **role assignments**.  
- Validate **incident creation & sync** (alerts roll into incidents, AIR can trigger, Action centre logs actions).

---

## Attack Chain Coverage
| Stage (examples) | Primary control | How it works | Setup essentials |
|---|---|---|---|
| Initial access (phish/URL/file) | **Defender for Office 365** | Safe Links/Attachments detonate & rewrite; anti-phish policies | Enable preset security policies; configure Safe Links/Attachments |
| Exploitation / C2 / persistence | **Defender for Endpoint** | EDR behavioural detections, isolation, live response | Onboard devices (Intune/ConfigMgr/scripts); set automation levels; device groups |
| Credential theft & lateral movement | **Defender for Identity** | DC/ADFS/ADCS sensors detect AD attacks (Kerberoasting, DCSync) | Install sensors on DCs; ensure outbound connectivity; grant required permissions |
| Risky sign-ins / compromised accounts | **Entra ID Protection** | User & sign-in risk policies enforce MFA / password reset | Entra ID P2; configure risk policies + Conditional Access |
| SaaS misuse / exfiltration / Shadow IT | **Defender for Cloud Apps** | Cloud Discovery; session control; file governance | Connect apps (API connectors); enable Cloud Discovery; CA App Control |
| Industrial/IoT exploitation | **Defender for IoT/OT** | Passive network sensors, protocol analysis, anomaly detection | Deploy sensors; connect to Defender; baseline segments/devices |

**Instructor note:** Layered coverage means failures at one stage are caught at another—**provided** onboarding and policies are correctly configured.

---

## Incident Management
**What it does:**  
- **Incidents**: roll up alerts + entities + evidence into one case.  
- **Automatic Attack Disruption**: machine-speed containment (e.g., device isolation, user suspension) on high-confidence chains.  
- **AIR**: expands scope, gathers artefacts, and remediates per automation level.  
- **Action centre**: audit trail of automated and manual actions.

**How it works:**  
Correlation unifies alerts sharing kill-chain stages/entities. Disruption policies and AIR run playbooks aligned to device groups’ automation settings (Full/Semi/None). Analysts review, approve, or block actions, add tags/owners, and close with reason.

**Setup requirements:**  
- Set **automation level** per device group (Full/Semi/None).  
- Configure **email notifications**, **incident settings**, and **alert tuning**.  
- Validate **disruption eligibility** (prereqs met, integration with Intune/Defender for Endpoint for isolation).

**Triage checklist:**  
1) Validate scope (assets/evidence). 2) Contain (isolate host / suspend user). 3) Eradicate (AV scan, IOC block). 4) Recover (unblock, rejoin). 5) Lessons learned (rule/policy/tuning updates).

---

## Advanced Hunting (KQL)
**What it does:**  
Query up to ~30 days of raw events across Defender tables to:  
- Validate incidents & root cause.  
- Find **IOCs/behaviours** beyond existing analytics.  
- **Publish custom detections** from hunts.

**Setup requirements:**  
- Appropriate Defender roles (Security Reader/Operator+).  
- Access **Hunting** in `security.microsoft.com`.  
- Know table names (e.g., `DeviceProcessEvents`, `DeviceNetworkEvents`, `EmailEvents`, `AlertInfo`, `AlertEvidence`, `AADSignInEventsBeta`).

**Operational tip:**  
Standardise hunt query storage (naming, owners, tags), peer-review before promotion, and attach response playbooks when creating scheduled detections.

---

## Microsoft Security Graph API (investigation at scale)
**What it does:**  
Provides programmatic access to security alerts/incidents/indicators across Microsoft security solutions.

**Setup requirements:**  
- Register an app in Entra ID; grant **Security** API permissions (app or delegated) and consent.  
- Use Graph Explorer or SDKs (PowerShell/REST) to query incidents/alerts and automate triage.

**Typical uses:**  
- Pull a daily incident feed for ticketing.  
- Bulk close false positives with consistent closing reasons.  
- Fetch alert evidence for DFIR pipelines.

---

## Defender Integrations (Workload Deep Dives)

### Defender for Office 365 (MDO)
**What it does:**  
Stops phishing, malware, and URL-based attacks; provides **Threat Explorer**, **Attack Simulator**, and post-delivery actions (ZAP).

**How it works:**  
Inbound mail passes through multi-stage filtering (sender/auth reputation, content detonation, URL time-of-click protection). Threat Explorer pivots across senders, URLs, campaigns, and entities.

**Setup requirements:**  
- Turn on **Preset Security Policies** (Standard/Strict) or custom: **Safe Links**, **Safe Attachments**, **Anti-Phish**.  
- Integrate with Defender XDR (automatic) for incident correlation.  
- Configure user reporting (Report Message add-ins) and admin review queues.

**Validation:**  
Send test phish with **Attack Simulator**; verify Safe Links rewriting and detonation verdicts appear in incidents.

---

### Defender for Endpoint (MDE)
**What it does:**  
EDR/EPP with behavioural detections, **isolation**, **containment**, **AV scanning**, **live response**, **TVM** (vulnerability management).

**How it works:**  
The endpoint sensor streams process, file, registry, network, and identity signals. Analytics flag anomalies; **AIR** and **isolation** can auto-remediate. **Live Response** allows scripted forensics.

**Setup requirements:**  
- **Onboard devices** (Intune/ConfigMgr/GPO/script/MDM).  
- Configure **device groups** + **automation levels**; enable needed **Advanced features**.  
- Integrate with **Intune** for compliance + Conditional Access “block at risk”.

**Validation:**  
Check devices appear in inventory; trigger an EICAR/safe test to see alert→incident; test **isolate device** and review Action centre.

---

### Defender for Identity (MDI)
**What it does:**  
Detects AD-centric attacks (e.g., LDAP enumeration, password spraying, DCSync, Golden Ticket) and surfaces **Lateral Movement Paths (LMPs)**.

**How it works:**  
Lightweight sensor on DCs/ADFS/ADCS analyses auth and directory traffic; cloud analytics raise detections and map LMPs from exposed identities to Tier-0 assets.

**Setup requirements:**  
- Install sensors on **all DCs** (and ADFS/ADCS where applicable).  
- Ensure DCs have outbound access to Defender service.  
- Grant directory read permissions as per guidance.

**Validation:**  
Confirm sensors healthy; simulate safe queries (e.g., LDAP enumeration in a lab) and review detections & LMPs.

---

### Entra ID Protection
**What it does:**  
Assigns **user risk** and **sign-in risk**; applies conditional controls (MFA/Password reset) to mitigate account compromise.

**How it works:**  
Risk is calculated using ML (impossible travel, anonymous IP, unfamiliar sign-in properties, leaked creds). Policies auto-enforce remediation.

**Setup requirements:**  
- **Entra ID P2**.  
- Configure **User risk policy** (require secure password change with MFA).  
- Configure **Sign-in risk policy** (require MFA for medium/high).  
- Integrate with Conditional Access and SSPR.

**Validation:**  
Use a test account to simulate risky sign-in (from TOR/VPN in lab where permitted) and confirm policy prompts/remediation.

---

### Defender for Cloud Apps (MDCA)
**What it does:**  
Discovers Shadow IT, connects to SaaS apps via APIs, and enforces **session controls** (download block, watermark, monitor) via **Conditional Access App Control**.

**How it works:**  
- **Cloud Discovery:** ingest firewall/proxy logs or endpoint signals to find app usage.  
- **API connectors:** pull app events/files/users for governance and DLP.  
- **Session control:** real-time reverse-proxy for inline policies.

**Setup requirements:**  
- Enable **Cloud Discovery** (log collectors or MDE integration).  
- Connect key apps (Microsoft 365, Box, Salesforce, Google Workspace, etc.).  
- Configure **Session** and **File** policies; integrate with **Conditional Access**.

**Validation:**  
Block unsanctioned app uploads in session control; observe policy hits and incident creation in Defender XDR.

---

### Defender for IoT/OT
**What it does:**  
Profiles unmanaged IoT/OT assets and detects anomalous protocols/commands in industrial networks.

**How it works:**  
Passive sensors tap SPAN ports; protocol decoders identify device types and risky behaviours; findings flow to Defender XDR.

**Setup requirements:**  
- Deploy **network sensors** at key segments.  
- Baseline assets and define **zones/criticality**.  
- Integrate with Defender XDR; plan change windows with OT teams.

**Validation:**  
Confirm asset discovery; generate benign traffic in a lab to validate detections and incident visibility.

---

## Secure Score, Threat Analytics & Reporting
**What they do:**  
- **Secure Score:** prioritised hardening recommendations across workloads.  
- **Threat Analytics:** curated briefs on active threats, organisational exposure, and mitigations.  
- **Reports:** device/email/identity posture & trends.

**Setup:**  
No extra licence beyond workloads; ensure each product is connected so posture signals feed into XDR. Review regularly; create **improvement plans**.

**Validation:**  
Track Secure Score trends after policy rollouts; map Threat Analytics mitigations to change tickets.

---

## Action Centre & Submissions
**What it does:**  
- **Action centre:** audit and control for automated/manual actions (e.g., isolate, AV scan, IOC block).  
- **Submissions:** submit files/URLs/email samples for deeper analysis.

**Setup:**  
Grant operators permissions to approve/rollback actions. Define **approval workflows** for Semi-automation device groups.

**Validation:**  
Run a test AV scan or isolation; verify entries and outcomes in Action centre.

---

## Lab (Module 1)
**Objectives:**  
- Apply **Defender for Office 365** preset policies.  
- Prepare **Defender XDR** workspace & automation levels.  
- Investigate an incident end-to-end; use AIR and Action centre.

**Pre-lab checklist:**  
- Lab tenant with appropriate licences.  
- Test devices onboarded to MDE; test mailbox; a DC (for MDI) in lab.  
- Admin and analyst accounts with scoped permissions.

---

## Quick Setup Checklist (Instructor)
- [ ] Assign licences; verify portal access.  
- [ ] Onboard endpoints; create device groups & automation levels.  
- [ ] Enable MDO preset policies; Safe Links/Attachments.  
- [ ] Install MDI sensors on DCs; validate health.  
- [ ] Configure Entra ID user/sign-in risk policies.  
- [ ] Connect MDCA apps; enable Cloud Discovery & key policies.  
- [ ] (If applicable) Deploy IoT/OT sensors; integrate with XDR.  
- [ ] Configure notifications, Action centre review process, and alert tuning.  
- [ ] Validate end-to-end incident creation and disruption.

---

## Key Takeaways
- Defender XDR **correlates** multi-domain alerts into a single, rich incident.  
- **Automation + disruption** shrink dwell time and raise SOC capacity.  
- **Hunting + custom detections** turn hypotheses into continuous detection logic.  
- Success depends on **correct onboarding and policy configuration** across each Defender product, plus **RBAC & process**.
