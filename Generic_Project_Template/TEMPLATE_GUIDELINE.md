# Generic Project Engineering Template

This directory contains the **Universal, Framework-Agnostic Software Engineering Template** and pair-programming lifecycle methodology.

---

## 🎯 Purpose & Design Philosophy

1. **100% Framework & Technology Neutral**:
   - This template contains **zero mentions** of specific frameworks, libraries, database engines, cloud vendors, or domain terms.
   - It is designed to guide **any** software project across web, mobile, desktop, distributed systems, embedded, or enterprise backends.

2. **Core Deliverable**:
   - [`Any Project Skill.docx`](./Any%20Project%20Skill.docx): The master engineering guideline document defining:
     - **The AI-Assisted Pair Programming Framework** (Human Architect vs AI Implementer roles, 6-stage pair programming loop, multi-tier testing matrix, and architectural invariants).
     - **The 8-Step Universal Project Lifecycle** (Step-1 through Step-8) with strict placement rationales and quality gates.

---

## 🏛️ The Universal 8-Step Lifecycle

```mermaid
flowchart TD
    S1["Step-1: Requirement Gathering & Knowledge Ingestion"] --> S2["Step-2: Layered Directory Scaffolding & Architecture"]
    S2 --> S3["Step-3: Data Contracts, Mock Repository & UI Prototype"]
    S3 --> S4["Step-4: Persistent Schema Modeling & Migration Engine"]
    S4 --> S5["Step-5: Backend Core Engine, Domain Services & APIs"]
    S5 --> S6["Step-6: Full-Stack Integration & Wire-Up"]
    S6 --> S7["Step-7: Automated Multi-Tier Testing & Quality Gates"]
    S7 --> S8["Step-8: CI/CD Automation, Cloud Deployment & Delivery"]
```

---

## ⚖️ Distinction: Template vs Project Specifications

| Directory | Scope | Specificity | Contents |
|---|---|---|---|
| [`Generic_Project_Template/`](.) | **Universal** | **100% Framework-Agnostic** | Reusable for ANY project (no vendor/framework names). |
| [`specifications/`](../specifications/) | **Project-Specific** | **100% StarkGroup-VMS Specific** | Formal specifications for StarkGroup-VMS (Spring Boot 3.3, Java 21, PostgreSQL 16, Flutter Web, Dio, Docker). |

