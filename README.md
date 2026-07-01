# 🚀 Linux Infrastructure Hardening, Routing & Automation

## 📌 About the Project
This hands-on project simulates the deployment, hardening, and automation of a web server within an enterprise production environment. Rather than relying on insecure default setups, the core focus is placed on **system hardening**, **strict least-privilege access control**, and **data resilience** against system failures.

The primary objective is to guarantee that a web application runs isolated, highly available, and with a minimized system attack surface.

---

## 🎯 Key Demonstrated Competences (Value for DevOps / Technical Support)

* **System Architecture & Process Management:** Deep understanding of the Linux lifecycle, shifting init setups, and troubleshooting services directly controlled by `systemd` (**PID 1**).
* **Security & Least-Privilege Access Control:** Implementing complete application isolation by eliminating root-level execution. Fine-grained control using Linux permissions (`chmod 750 / 640`) and group/owner structures (`chown`).
* **Network Engineering & Diagnostics:** Production-level port conflict resolution (migrating sockets, debugging using `ss`), local domain routing via DNS resolution mapping (`/etc/hosts`), and end-to-end HTTP payload validation (`curl`, `ping`).
* **Perimeter Security (Firewalling):** Programmatically enforcing a strict firewall perimeter using `UFW`, setting default-deny incoming baselines, and whitelisting explicit operational ports.
* **Automation & Bash Scripting:** Designing reusable infrastructure scripts featuring dynamic exit-code handling (`$?`) and scheduling standalone background operations via the `cron` daemon.

---

## 🛠️ Technical Stack
* **OS:** Linux Ubuntu (WSL2 environment configured with Systemd active)
* **Web Server & Reverse Proxy:** Nginx
* **Security:** UFW (Uncomplicated Firewall)
* **Automation:** Bash Scripting, Crontab

---

## 🗺️ Architecture & Implementation Phases

### 1️⃣ System Initialization (`systemd`)
To align with standard enterprise production environments, the runtime environment was tailored to run `systemd` as the main initialization process (**PID 1**).
* *Verification Command:* `ps -p 1 -o comm=` (Output: `systemd`)

### 2️⃣ Network Port Conflict Resolution (Port 80)
During the Nginx deployment phase, a deep network socket analysis via `sudo ss -tulpn | grep :80` detected a binding failure. An existing Apache2 service was actively occupying the port.
* *DevOps Action:* Stopped and disabled the conflicting Apache2 service (`systemctl disable/stop apache2`), freeing up the standard HTTP port 80 exclusively for Nginx.

### 3️⃣ Application Isolation (Least-Privilege Principle)
To prevent potential web-layer vulnerabilities from compromising the entire host OS:
* Created a dedicated system user `alice` and an operations group `devops`.
* Transferred ownership of the web root folder `/var/www/html` to `alice:devops`.
* Enforced strict read/write/traverse boundaries: `chmod 750` (Owner has full access, group can read/traverse, others are completely restricted).
* Integrated the Nginx service runtime user (`www-data`) into the `devops` group to bypass a security-driven *HTTP 403 Forbidden* error safely.

### 4️⃣ Firewall Hardening (`UFW`)
Automated network boundary protection using the `scripts/secure_server.sh` script:
* Set a baseline policy dropping all unauthorized incoming traffic (`deny incoming`).
* Whitelisted exclusive ports: `80/tcp` for public web traffic and `22/tcp` for secure administrative remote maintenance (SSH).

### 5️⃣ Automated Backup Scripting & Task Scheduling
Engineered a resilient backup pipeline (`scripts/system_backup.sh`) that handles:
* Dynamic data packaging using `.tar.gz` archive generation stamped with real-time timestamps (`$(date +%F)`).
* Strict validation checkpoints inspecting execution codes (`if [ $? -eq 0 ]`) ensuring backup health before validation.
* Registered the script within **Cron** (`crontab -e`) to execute automatically every night at 2:00 AM, routing all processing stdout/stderr output into a dedicated logging file (`backup.log`).

---

## 📁 Repository Structure
```text
ln-labs/
├── README.md                 # Main project documentation
├── cron/
│   ├── backup-2026-07-01.tar.gz  # Automated scheduled archives
│   └── backup.log                # Real-time crontab execution journals
└── scripts/
    ├── setup_users.sh            # Initializes system IAM, groups, and permissions
    ├── secure_server.sh          # Handles network boundary defense and UFW setups
    └── system_backup.sh          # Automated data packaging and script error validation
