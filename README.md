# ChildVaccine

![ChildVaccine Logo](https://img.shields.io/badge/Java-1.8-blue) ![NetBeans](https://img.shields.io/badge/IDE-NetBeans%208.2-orange) ![Database](https://img.shields.io/badge/Database-SQL%20Server-blue)

## 📌 Introduction
ChildVaccine is a Java-based application designed to efficiently manage children's vaccination records. The system allows healthcare providers and parents to track vaccinations, manage patient records, and generate reports. This project is built using **JDK 1.8** and developed on **NetBeans 8.2**, with **SQL Server** as the database management system.

This system is intended to ensure that children receive timely vaccinations and that medical professionals can easily track and manage their records. It helps in reducing paperwork and enhances data accuracy while maintaining a secure and efficient database for healthcare providers.

---

## 📁 Project Structure
The project follows a structured organization for ease of development and maintenance:

- **`src/`**: Contains all Java source code files.
- **`src/java/utils/DBUtils.java`**: Handles database connectivity settings.
- **`ChildVaccine.sql`**: SQL script to set up the database schema and initial data.
- **`build.xml`**: Configuration file for NetBeans to build and run the project.
- **`web/`**: Contains frontend web resources if applicable.
- **`dist/`**: Stores the compiled version of the application.
- **`test/`**: Contains unit tests for different modules.
- **`LICENSE`**: Defines the open-source license for the project.

---

## 🔧 System Requirements
To ensure smooth installation and execution, please ensure you have the following dependencies installed:

- **Java Development Kit (JDK) 1.8** or later.
- **NetBeans 8.2** (or any compatible Java IDE).
- **SQL Server** for managing the vaccine records database.
- **Apache Ant** (if you want to build the project using `build.xml`).

---

## 🚀 Features

### 📌 User Authentication
- Secure login system for authorized users (administrators, doctors, healthcare providers).
- Ensures data privacy and restricted access to sensitive information.

### 📌 Manage Vaccination Records
- Add, update, and delete child vaccination records.
- Tracks upcoming vaccinations based on immunization schedules.
- Provides reminders for overdue vaccinations.

### 📌 Patient Management
- Maintain records of children's personal details.
- Store contact information for parents or guardians.

### 📌 Generate Reports
- View vaccination history by child or by vaccine type.
- Generate reports for healthcare analysis and monitoring.

### 📌 Secure Database Interaction
- Uses **SQL Server** for secure data storage and management.
- Implements encryption and authentication mechanisms to protect records.

### 📌 User-Friendly Interface
- Simple and intuitive UI for easy navigation.
- Well-structured forms and data tables for efficient data entry and retrieval.

### 📌 Scalability & Performance
- Designed to support a growing number of records.
- Optimized queries for fast and efficient data access.

---

## 🚀 Installation & Setup

### 1️⃣ Clone the Repository
First, download or clone the repository from GitHub:
```sh
git clone https://github.com/Nyakkon/child-vaccine.git
cd child-vaccine
```

### 2️⃣ Open Project in NetBeans
- Launch **NetBeans 8.2** (or any compatible IDE).
- Click on **File** → **Open Project**.
- Select the `ChildVaccine` folder and click **Open**.

### 3️⃣ Build & Run the Application
- Build the project using `build.xml`.
- Run the project from NetBeans by clicking **Run Project (F6)**.

---

## 🔧 Database Configuration
The application connects to a SQL Server database using JDBC. Follow these steps to configure the database connection properly:

### 1️⃣ Setting Up SQL Server
- Install Microsoft SQL Server and SQL Server Management Studio (SSMS) if not already installed.
- Open SSMS and create a new database named **ChildVaccine**.
- Run the SQL script `ChildVaccine.sql` in SSMS to create tables and insert initial data.

### 2️⃣ Configuring Database Connection in `DBUtils.java`
Navigate to `src/java/utils/DBUtils.java` and update the connection parameters:
```java
private static final String DB_NAME = "ChildVaccine";
private static final String USER_NAME = "sa";
private static final String PASSWORD = "your_password";
```
Ensure that your SQL Server is running and allows connections via **SQL Server Authentication**.

### 3️⃣ Testing the Connection
To verify the database connection:
- Open **NetBeans** and run the application.
- If the database is correctly configured, the application should start without errors.

---

## 📌 Git Workflow
To collaborate effectively, follow this Git workflow:

### 1️⃣ Create a New Branch
Before making changes, create a new branch:
```sh
git checkout -b feature-branch-name
```

### 2️⃣ Make Changes & Commit
After making necessary changes, commit your updates:
```sh
git add .
git commit -m "Your meaningful commit message"
```

### 3️⃣ Push to GitHub
Push the changes to the repository:
```sh
git push origin feature-branch-name
```

### 4️⃣ Create a Pull Request
- Go to the repository on GitHub.
- Click on **Pull Requests**.
- Select your branch and submit a pull request for review.

---

## 🌍 Contribution Guidelines
We welcome contributions! Follow these steps to contribute:

1. **Fork the repository** on GitHub.
2. **Create a new feature branch**.
3. **Commit your changes** with descriptive messages.
4. **Push to your fork** and create a pull request.
5. **Wait for a review** and make necessary adjustments.

---

## 🛡️ Security & Best Practices
- Use **environment variables** instead of hardcoding credentials in `DBUtils.java`.
- Regularly update dependencies to prevent vulnerabilities.
- Follow proper **Git commit practices** for better collaboration.

---

## 📜 License
This project is licensed under the MIT License.

---

## 👥 Development Team
This project was developed for the SWP391 course by **Team 4 SWP391, Class NJS1802**.

---

## 📬 Contact Information
For any questions or technical support, please contact the development team at:

📧 **Email:** [miko@wibu.me](mailto:miko@wibu.me)

🌟 **Star this repository** if you found it helpful!

