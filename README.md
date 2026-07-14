# AWS-Cloud-Security-Labs
A collection of hands-on labs and documentation focusing on AWS penetration testing, IAM security mapping, and cloud infrastructure hardening.
# AWS Cloud Security Project: Identity & Storage Enumeration

*   **Platform:** CYBR Training Labs
*   **Course:** Introduction to AWS Enumeration
*   **Core Focus:** AWS IAM Security, Cloud Discovery, and Metadata Leaks

---

## Project Overview
This project demonstrates how attackers find and map hidden assets inside Amazon Web Services (AWS). Using a low-privilege user account, I scanned the cloud environment, found misconfigured access controls, and used an advanced tool to safely extract a hidden AWS Organization ID from a storage bucket.

---

## Phase 1: Checking the Environment & Identity

1.  **Setting Up the AWS CLI:** Installed the official AWS Command Line Interface (CLI) and checked the version to make sure it was fully updated.
2.  **Configuring Access:** Logged into the target environment using an Access Key and a Secret Key. Locked the region to `us-east-1` because the lab infrastructure only responds to this specific area.
3.  **Finding My Username:** Ran the command `aws sts get-caller-identity`. This confirmed that my active session belonged to a user named **Dana**.
4.  **Mapping Out Roles:** Ran `aws iam list-roles`. This gave me a large list of cloud roles, including their **ARNs** (Amazon Resource Names), which are the unique IDs needed to track assets.

---

## Phase 2: Finding Weak Permissions (IAM Scanning)

*   **Handling Access Errors:** When I tried to run major administrative commands, the system blocked me with an `AccessDenied` error. This told me exactly where the security walls were built.
*   **Finding Other Users:** Ran `aws iam list-users` to see who else was in the system. I successfully discovered a second user named **Mary**.
*   **Analyzing Security Policies:** 
    *   I checked Dana's account and found an active policy named `allow-enumeration`. This policy explicitly allowed the user to list and read global IAM settings.
    *   I checked Mary's account, but it was completely empty. This highlighted a key cloud concept: **permissions are usually given to Groups, not individual users.**
*   **Finding the Path to Storage:** I discovered a policy called `allow-s3-operations`. This policy was too broad and gave my user the right to view and read data inside the Amazon S3 storage ecosystem.

---

## Phase 3: Smart Data Extraction (S3 Bucket Exploit)

Instead of trying billions of random guesses to find the secret **AWS Organization ID** (which takes too long and makes too much noise), I used a smarter method:

*   **The Tool:** Used a specialized Python security tool named `conditional-love`.
*   **How it Works:** The tool exploits the way AWS checks security rules. By using a trick called a `StringLike` wildcard search, the tool guesses the secret ID **one letter at a time**. 
*   **The Result:** The tool successfully found the hidden AWS Organization ID in just **360 quick attempts**, bypassing standard brute-force blocks.

---

## Key Security Fixes (Blue Team Recommendations)

To protect a real company from these types of scans, I recommend three rules:
1.  **Use Least Privilege:** Never use wildcards (`*`) in security policies. Only give users access to the exact tools they need to do their jobs.
2.  **Tighten Storage Policies:** Restrict S3 bucket rules so they do not leak metadata or organization details to outsiders.
3.  **Turn on Logging:** Keep AWS `CloudTrail` active to instantly catch anyone running high-frequency commands or scanning user lists.
