# Brighton and Hove Albion FC Data Agent

A comprehensive AI-powered football club data analysis agent built with Google's Agent Development Kit (ADK) and BigQuery. This agent can analyze all aspects of Brighton and Hove Albion FC's football club operations using real-time data queries.

## 🏆 Features

The agent provides comprehensive analysis across 18 data tables covering:

### ⚽ Core Football Data
- **Matches**: All match results, dates, venues, scores, and attendance
- **Players**: First team squad with personal details, positions, nationalities
- **Player Stats**: Individual performance data per match
- **Player Injuries**: Injury tracking and recovery timelines
- **Transfers & Contracts**: Contract details, salaries, transfer fees
- **Player Transfers**: Historical transfer data
- **Player Valuations**: Market value tracking over time

### 👥 Fan & Commercial Data
- **Fan Database**: 1M+ fan records with demographics and engagement
- **Ticket Sales**: Individual ticket purchases with pricing and seating
- **Merchandise Sales**: Product sales data from club stores
- **Concession Sales**: Food and beverage sales at matches
- **Employees**: Club staff across all departments
- **Sponsorships**: Commercial deals and partnership agreements
- **Social Media**: Engagement metrics and performance data
- **Club Finances**: Annual financial performance data
- **Supplier Contracts**: Agreements with operational suppliers

### 🏆 Youth Development
- **Youth Academy**: Young players in the academy system
- **Scouting Reports**: Assessments of potential transfer targets

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- Google Cloud Project with BigQuery enabled
- Application Default Credentials configured

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd bq-agent-project
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Set up BigQuery dataset**
   ```bash
   # Run the data generation script to create the football_agent dataset
   ./setup_dataset.sh
   ```

4. **Configure authentication**
   ```bash
   # Set up application default credentials
   gcloud auth application-default login
   ```

## 🎯 How to Use the Agent

### Option 1: ADK CLI (Recommended - Full Functionality)

The agent works perfectly with the ADK CLI interface:

```bash
# Start the agent in CLI mode
adk run football-agent
```

Then ask questions like:
- "Tell me about our fans"
- "What are our match results?"
- "Show me player statistics"
- "How much revenue do we generate from ticket sales?"

### Option 2: ADK Web Interface (Web-based UI)

For a modern web-based interface with automatic session management:

```bash
# Start the ADK web interface
adk web
```

Then navigate to the web interface (typically `http://localhost:8080`) and interact with the agent through the browser.

**ADK Web Features:**
- ✅ Automatic session management
- ✅ Implicit memory handling  
- ✅ Real-time BigQuery queries
- ✅ Modern web UI
- ✅ Perfect for testing and prototyping

## 💬 Example Queries

The agent can handle a wide variety of questions about Brighton and Hove Albion FC:

### Match & Performance Analysis
- "What are our top performing players this season?"
- "How many goals have we scored this season?"
- "What's our average attendance?"
- "Show me our recent match results"

### Financial & Commercial
- "How much revenue do we generate from ticket sales?"
- "What's the value of our sponsorship deals?"
- "Which products sell best in our merchandise store?"
- "What's our total commercial revenue?"

### Fan Engagement
- "Who are our most engaged fans?"
- "What's the demographic breakdown of our fan base?"
- "How many paid app members do we have?"
- "Which countries have the most Brighton and Hove Albion FC fans?"

### Squad Management
- "What's our injury situation like?"
- "How many players do we have in each position?"
- "Show me our youth academy players"
- "What are our recent scouting reports?"

### Social Media & Marketing
- "How are our social media posts performing?"
- "Which social media platform gets the most engagement?"
- "What types of posts perform best?"

## 🛠️ Technical Architecture

### Built with:
- **Google ADK**: Agent Development Kit for AI agent functionality
- **BigQuery**: Cloud data warehouse for storing and querying data
- **Gemini 2.5 Flash**: Advanced language model for natural language processing

### Key Components:
- `football-agent/agent.py`: Main agent definition with custom BigQuery tools.
- `football-agent/prompt.py`: Detailed instructions and logic for the agent's behavior.
- `data_generation.sql`: Complete dataset creation script with 18 tables.
- `setup_dataset.sh`: BigQuery dataset initialization script.
- `requirements.txt`: Python dependencies including google-adk and bigquery.

## 📊 Data Schema Overview

The `football_agent` dataset contains 18 interconnected tables:

1.  **fan_database** (1M+ records): Fan demographics and engagement
2.  **matches**: Match results and attendance data
3.  **players**: Squad information and personal details
4.  **player_stats_per_match**: Individual performance metrics
5.  **ticket_sales**: Ticket purchase transactions
6.  **merchandise_sales**: Product sales data
7.  **employees**: Club staff and organizational structure
8.  **sponsorships**: Commercial partnership agreements
9.  **youth_academy_players**: Young player development
10. **player_injuries**: Injury tracking and recovery
11. **social_media_engagement**: Marketing performance metrics
12. **player_transfers_and_contracts**: Financial and contractual data
13. **matchday_concession_sales**: Matchday revenue streams
14. **scouting_reports**: Transfer target assessments
15. **player_transfers**: Historical transfer data
16. **player_valuations**: Market value tracking over time
17. **club_finances**: Annual financial performance
18. **supplier_contracts**: Operational supplier agreements

## 🔧 Configuration

### Environment Variables
- `