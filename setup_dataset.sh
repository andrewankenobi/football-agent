#!/bin/bash

# Brighton & Hove Albion FC Data Agent - Dataset Setup Script
# This script creates the football_agent dataset in BigQuery with realistic,
# synthetic data for Brighton & Hove Albion FC.

set -e

echo "⚽ Brighton & Hove Albion FC Data Agent - Dataset Setup"
echo "========================================================"
echo ""

# Check if bq command is available
if ! command -v bq &> /dev/null; then
    echo "❌ Error: BigQuery CLI (bq) is not installed or not in PATH"
    echo "Please install the Google Cloud SDK: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if data_generation.sql exists
if [ ! -f "data_generation.sql" ]; then
    echo "❌ Error: data_generation.sql file not found"
    echo "Please ensure you're running this script from the project root directory"
    exit 1
fi

# Get current project
CURRENT_PROJECT=$(gcloud config get-value project 2>/dev/null || echo "")

if [ -z "$CURRENT_PROJECT" ]; then
    echo "❌ Error: No Google Cloud project is set"
    echo "Please set your project: gcloud config set project YOUR_PROJECT_ID"
    exit 1
fi

echo "📊 Current Google Cloud Project: $CURRENT_PROJECT"
echo ""

# Confirm before proceeding
read -p "Do you want to create the football_agent dataset for Brighton & Hove Albion in project '$CURRENT_PROJECT'? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
fi

echo ""
echo "🚀 Recreating all tables in the football_agent dataset..."
echo "This may take a few minutes..."

# Create the dataset. This will fail gracefully if it already exists.
# The CREATE OR REPLACE statements in the SQL script will handle the table recreation.
echo "📁 Ensuring football_agent dataset exists..."
bq mk --dataset --description "Brighton & Hove Albion FC Data" --project_id=$CURRENT_PROJECT football_agent >/dev/null 2>&1 || true

# Run the SQL script to create or replace all tables
echo "📊 Creating/replacing tables and populating data for Brighton & Hove Albion..."
bq query --use_legacy_sql=false --project_id=$CURRENT_PROJECT < data_generation.sql

echo ""
echo "✅ Dataset setup complete!"
echo ""
echo "📋 Created tables:"
echo "   • players (Realistic BHA squad)"
echo "   • matches (Match results and attendance)"
echo "   • fan_database (500k fan records)"
echo "   • employees (Club staff)"
echo "   • ticket_sales (Ticket sales data)"
echo "   • player_stats_per_match (Performance data)"
echo "   • merchandise_sales (Product sales)"
echo "   • sponsorships (Commercial deals)"
echo "   • youth_academy_players (Academy players)"
echo "   • player_injuries (Injury tracking)"
echo "   • social_media_engagement (Marketing data)"
echo "   • player_contracts (Player salaries)"
echo "   • matchday_concession_sales (Matchday revenue)"
echo "   • scouting_reports (Transfer targets)"
echo "   • player_transfers (Transfer history)"
echo "   • player_valuations (Market value tracking)"
echo "   • club_finances (Annual financial performance)"
echo "   • supplier_contracts (Operational supplier agreements)"
echo ""
echo "🎯 Next steps:"
echo "   1. Start the agent: adk web"
echo "   2. Open your browser to the provided localhost address."
echo "   3. Ask questions about Brighton & Hove Albion FC data!"
echo ""
echo "⚽ Ready to analyze Brighton & Hove Albion's comprehensive data!" 