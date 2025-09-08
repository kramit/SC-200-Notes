# Module 2 – Describe Microsoft Security Copilot

## Overview
**Microsoft Security Copilot** is an AI-powered, cloud-based security analysis tool that combines large language models (LLMs) with a Microsoft security-specific model. It integrates with Microsoft and third-party security products to **summarize incidents, analyze scripts, generate guided responses, and turn natural language into investigations**. Copilot is available as a **standalone experience** and via **embedded experiences** inside solutions like Microsoft Defender XDR, Microsoft Entra, and Microsoft Purview.

**How it works:**  
Copilot’s **orchestrator** routes your prompt to the right **capabilities** and **plugins** (for example, Defender XDR, Entra, Purview). It retrieves relevant data, applies security-tuned reasoning, and returns a response with a **process log** that shows which capabilities were used and that the output passed Microsoft’s safety checks.

**Setup (at a glance):**
- **Provision capacity (SCUs):** In `https://securitycopilot.microsoft.com`, choose an Azure subscription & resource group, then allocate **Security Compute Units (SCUs)**.
- **Set default environment:** Pick data location (tenant geography), configure data sharing options, and finalize baseline settings.
- **Assign roles:** Use **Copilot Owner** and **Copilot Contributor** (Copilot-scoped roles, not Entra roles) and ensure necessary Entra roles (e.g., Global/Security Admin) for initial setup.
- **Enable plugins:** Turn on Microsoft and third-party plugins you plan to use (some require additional configuration/auth).
- **(Optional) Configure embedded experiences:** Enable the relevant product plugins (e.g., Defender XDR) and ensure users have permissions in those products.

---

## What Security Copilot Is (and isn’t)
**What it does:**
- **Incident summarization & impact analysis:** Condense alerts and related evidence into clear, actionable narratives.
- **Guided responses:** Step-by-step triage, containment, investigation, and remediation actions.
- **Script/code analysis:** Explain what a suspicious script does and identify risky behaviors.
- **Natural language to KQL:** Generate hunting queries and analytics starting from a plain-English goal.
- **Reporting & export:** Produce incident reports and export or copy responses for tickets and hand-offs.

**What it isn’t:**  
Copilot doesn’t replace your SIEM/XDR. It augments your SOC by speeding **analysis, investigation, and documentation**—using your existing data and controls.

---

## Core Concepts & Terminology
- **Session:** A conversation thread with context preserved across prompts.
- **Prompt:** A single request/question within a session.
- **Capability:** A function (e.g., “summarize incident”, “analyze file”) that Copilot invokes to answer part of a prompt.
- **Plugin:** A collection of capabilities tied to a product or service (e.g., Defender XDR, Entra).
- **Orchestrator:** The service that picks capabilities/plugins and composes a final response.
- **Process log:** Shows which capabilities ran and confirms safety filtering.

**Setup notes:**  
Ensure needed plugins are **enabled and authenticated**. Users must have **data access in the source products** (e.g., Defender XDR, Purview) or Copilot cannot retrieve information.

---

## Standalone Experience
**Key landmarks (Home menu):**  
- **My sessions** (history), **Promptbook library**, **Owner settings**, **Role assignments**, **Usage monitoring**, **Settings**, **Tenant switch**.

**Prompt bar:**  
- Access **promptbooks** (prebuilt workflows) and **sources** (plugins, uploaded files).
- Run prompts and see **process log**, **feedback**, **pinning**, **edit/rerun**, **export/copy** actions.

**Tenant switcher:**  
Work across a Copilot-provisioned tenant even if you sign in from another tenant (with appropriate access).

**Setup requirements:**  
Provision SCUs, set environment, assign roles, enable plugins, and optionally **upload files** (max ~3MB; supported types: .docx/.pdf/.txt/.md) then toggle them as sources for the session.

---

## Embedded Experiences
**Where it appears:**  
- **Microsoft Defender XDR:** Incidents, Advanced Hunting, device context.
- **Microsoft Purview:** eDiscovery/Compliance views.
- **Microsoft Entra:** Risky users/sign-ins and identity-centric investigations.

**Typical embedded capabilities:**  
- **Summarize incidents** (timeline, assets, IOCs, threat actor names when available).  
- **Guided responses** (triage, containment, investigation, remediation).  
- **Analyze scripts/files**, **generate KQL**, **create incident reports**, **summarize devices**.

**Setup requirements:**  
- Enable the **product plugin** (for example, Defender XDR plugin).  
- Ensure users have the right **product permissions** (e.g., Defender or Purview roles).  
- Validate access by opening an incident and using **Summarize** or another embedded action.

---

## Roles & Permissions
- **Copilot Owner / Copilot Contributor:** Copilot-scoped roles that control who can use and administer Copilot features.
- **Entra ID roles:** Needed for tenant-level tasks (e.g., **Global Administrator**, **Security Administrator**) and for accessing underlying product data.
- **On-behalf-of (OBO) sign-in:** Many Microsoft plugins use OBO so users automatically access resources they’re licensed for.

**Setup checklist:**  
1) Assign **Copilot Owner/Contributor** as appropriate.  
2) Verify users’ **product roles** (Defender, Entra, Purview) align with data you expect Copilot to access.  
3) Confirm **least-privilege** and auditing requirements.

---

## Capacity, Regions & Data
- **SCUs (Security Compute Units):** Capacity you allocate and monitor via **Usage monitoring** (filter by date, view consumption).
- **Data location:** Choose a geographic location for customer data storage in the **default environment**.
- **Safety & compliance:** Copilot responses go through safety checks; enterprise-grade controls support compliance requirements.

**Setup checklist:**  
- Allocate initial SCUs; monitor and **scale** as usage grows.  
- Select region that meets **data residency** needs.  
- Set **data sharing** preferences.

---

## Prompting & Promptbooks
**Effective prompts:**  
Be direct, supply relevant context (entity names, time ranges, incident IDs), and specify the desired output (summary, steps, next actions). When needed, ground Copilot on **uploaded files** or limit scope to specific **plugins**.

**Promptbooks:**  
Prebuilt multi-step workflows for common SOC tasks. You can also create **custom promptbooks**:
- Start from an existing session.
- Select which prompts to include, add descriptions/tags.
- Define **parameters** (use clear names in `<angle brackets>`).
- Save and share with your team.

**Setup requirements:**  
- Ensure **Owner** policies allow who can build/share promptbooks.  
- Establish **naming conventions**, tags, and review processes.

---

## Microsoft Plugins (Examples)
- **Defender XDR:** List/summarize incidents and alerts, analyze files/scripts, device posture, generate KQL.  
- **Entra:** Summarize risky users/sign-ins, policy context.  
- **Purview:** eDiscovery & audit context to support investigations.

**Setup requirements:**  
- Enable each plugin in **Sources**.  
- Verify product access/roles per user.  
- Test by running a simple capability (e.g., “Summarize this incident”).

---

## Third-Party & Custom Plugins
- **Third-party plugins (preview):** ServiceNow, Splunk, GreyNoise, CrowdSec, CIRCL Hash Lookup, etc. Typically require **setup & authentication** to the external service.
- **Custom plugins:** Build your own using **manifest** (.json/.yaml) that declares skills and invocation details.

**Setup requirements:**  
- For third-party: configure connectors/auth and confirm data scopes.  
- For custom: enable **Owner settings** that allow adding org-wide or per-user plugins; review/approve manifests.

---

## Files & Knowledge Sources
- **File uploads:** Add small reference files (policies, playbooks, runbooks). Toggle as a source to ground responses.
- **Knowledge base connections:** Use plugins (e.g., Defender XDR, Purview) as authoritative sources for investigations.

**Setup requirements:**  
- Enforce **file size/type** limits and **who can upload** (Owner setting).  
- Establish a content hygiene process (versioning, expiry, review).

---

## Usage Monitoring & Governance
- **Usage monitoring:** Track SCU consumption; filter by time; identify heavy use patterns.
- **Governance:** Define who can create promptbooks, add plugins, upload files, and export responses.
- **Auditability:** Use the **process log** and product logs to maintain an audit trail of actions and access.

**Setup checklist:**  
- Implement **role-based governance** for plugins/promptbooks/files.  
- Review **usage** monthly; scale SCUs as needed.  
- Define **export controls** and data handling guidelines.

---

## Quick Setup Checklist (Instructor)
- [ ] Provision **SCUs** and set **default environment** (region, data settings).  
- [ ] Assign **Copilot Owner/Contributor** and verify Entra/product roles.  
- [ ] Enable **Microsoft plugins** (Defender XDR, Entra, Purview) and test.  
- [ ] Configure **third-party/custom plugins** as required.  
- [ ] Establish **prompting standards** and **promptbook** governance.  
- [ ] Define **file upload** policy and approved sources.  
- [ ] Validate **embedded experiences** (e.g., Summarize in Defender XDR).  
- [ ] Set up **usage monitoring** and SCU scaling process.

---

## Validation Steps (Day 1 Smoke Test)
1) Create a **session**, run a basic prompt, inspect the **process log**.  
2) Execute a **prebuilt promptbook** and confirm outputs.  
3) In Defender XDR, open an incident and use **Summarize** or **Guided responses**.  
4) Export a response and confirm it meets ticketing/hand-off needs.  
5) Review **usage monitoring** to ensure capacity is reflected.

---

## Key Takeaways
- Security Copilot accelerates **investigation, response, and reporting** with AI while preserving product-level security boundaries.  
- Success depends on **capacity provisioning**, **roles & data access**, and **plugin enablement**.  
- Standardize **prompting practices**, **promptbooks**, and **governance** to make Copilot a repeatable force multiplier for your SOC.
