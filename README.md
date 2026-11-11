# SquareHealth-VMS (Stark Group Fleet Management System)

A full-stack, enterprise-ready Vehicle Management System developed with **Flutter Web**, **Java Spring Boot**, and **PostgreSQL/SQL Database**, paired with **Google Antigravity AI**.

---

## Project Structure Overview

```
SquiareHealth-VMS/
├── 1.Requirement_Gathering/             # Multi-source requirement ingestion pipeline & SRS
│   ├── Document/                        # Source Word specifications
│   ├── UdemyScrapper/                   # Scraped course curriculum (7 sections)
│   ├── YoutubeScrapper/                 # Audio files (.flac) & session transcripts (.md)
│   ├── Requirement Gathering.png        # Ingestion architecture diagram
│   └── REQUIREMENTS.md                  # Consolidated Single Software Requirements Specification
├── vms-frontend/                        # Flutter Web client (Feature-First Architecture)
│   ├── lib/
│   │   ├── core/                        # Theme, constants, networking, utilities
│   │   ├── features/                    # Auth, Vehicles, Maintenance, Documents, Drivers, Dashboard
│   │   └── shared/                      # Reusable widgets (AppShell, StatusBadge)
│   ├── web/                             # Web bootstrap files
│   └── test/                            # Flutter widget tests
├── vms-backend/                         # Java Spring Boot service (Layered Architecture)
│   ├── src/main/java/com/starkgroup/vms/
│   │   ├── controller/                  # REST Controllers (/api/v1/vehicles, /api/v1/auth)
│   │   ├── service/                     # Business logic & Duplicate Vehicle validation
│   │   ├── repository/                  # Spring Data JPA repositories
│   │   ├── entity/                      # Relational JPA entities
│   │   ├── dto/                         # Request & Response DTOs
│   │   ├── exception/                   # Global exception handling
│   │   └── config/                      # CORS & Security configs
│   └── src/test/java/                   # Unit (Mockito) & Integration (MockMvc) test suite
├── chat/                                # Conversation logs & session history
│   └── chat.md                          # Full transcript of user requests & agent actions
├── readme_folderstructure.md            # Detailed framework-specific & merged folder documentation
└── Any Project Skill.docx               # Step-by-step project blueprint
```

---

## Completed Phases

- **Step-1: Requirement Gathering**
  - Architecture for requirement gathering documented and visualized.
  - Audio file (`002 - Session  Weekly Support 01...flac`) transcribed into Markdown (`002 - Session  Weekly Support 01...md`).
  - Exhaustive consolidated requirements document created at [REQUIREMENTS.md](file:///c:/Users/USER/Documents/.MYGITHUB/SquiareHealth-VMS/1.Requirement_Gathering/REQUIREMENTS.md) with every requirement citing its source in brackets `[Source: ...]`.
- **Step-2: Folder Structure**
  - Official Flutter Web (frontend) and Spring Boot (backend) folder structures analyzed from official documentation.
  - Merged into a unified monorepo folder structure and created on disk.
  - Comprehensive explanation and architectural rationale documented in [readme_folderstructure.md](file:///c:/Users/USER/Documents/.MYGITHUB/SquiareHealth-VMS/readme_folderstructure.md).

