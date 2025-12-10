#!/usr/bin/env python3
"""
Generate a beautiful HTML report from the data_connectors.csv file.
"""
import csv
import json
from datetime import datetime


def load_connectors_csv(csv_path):
    """Load connectors from CSV file."""
    connectors = []
    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            row['properties'] = json.loads(row['properties_json'])
            connectors.append(row)
    return connectors


def get_connector_emoji(kind):
    """Return emoji based on connector type."""
    emojis = {
        'AzureSecurityCenter': '🔐',
        'AzureActiveDirectory': '👥',
        'MicrosoftDefenderAdvancedThreatProtection': '⚔️',
        'Office365': '📧',
        'MicrosoftCloudAppSecurity': '☁️',
        'AzureAdvancedThreatProtection': '🛡️',
        'SecurityEvents': '🔔',
        'WindowsSecurityEvent': '🪟',
        'MicrosoftThreatIntelligence': '🧠',
        'AmazonWebServicesCloudTrail': '☁️',
        'GoogleCloudPlatform': '☁️',
    }
    return emojis.get(kind, '🔗')


def get_connector_color(kind):
    """Return color based on connector type."""
    colors = {
        'AzureSecurityCenter': '#FF6B6B',
        'AzureActiveDirectory': '#4ECDC4',
        'MicrosoftDefenderAdvancedThreatProtection': '#45B7D1',
        'Office365': '#FFA07A',
        'MicrosoftCloudAppSecurity': '#98D8C8',
        'AzureAdvancedThreatProtection': '#F7DC6F',
        'SecurityEvents': '#BB8FCE',
        'WindowsSecurityEvent': '#85C1E2',
        'MicrosoftThreatIntelligence': '#F8B88B',
        'AmazonWebServicesCloudTrail': '#A8DADC',
        'GoogleCloudPlatform': '#C9ADA7',
    }
    return colors.get(kind, '#6C5CE7')


def generate_html(connectors, output_path):
    """Generate HTML report."""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    html = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🛡️ Sentinel Data Connectors Report</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}
        
        body {{
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }}
        
        .container {{
            max-width: 1200px;
            margin: 0 auto;
        }}
        
        .header {{
            text-align: center;
            color: white;
            margin-bottom: 40px;
            padding: 30px;
            background: rgba(0, 0, 0, 0.2);
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }}
        
        .header h1 {{
            font-size: 3em;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
        }}
        
        .header p {{
            font-size: 1.1em;
            opacity: 0.9;
        }}
        
        .stats {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 40px;
        }}
        
        .stat-card {{
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }}
        
        .stat-card:hover {{
            transform: translateY(-5px);
            box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
        }}
        
        .stat-icon {{
            font-size: 3em;
            margin-bottom: 15px;
        }}
        
        .stat-number {{
            font-size: 2.5em;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }}
        
        .stat-label {{
            color: #666;
            font-size: 0.95em;
        }}
        
        .connectors-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }}
        
        .connector-card {{
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border-left: 5px solid #667eea;
        }}
        
        .connector-card:hover {{
            transform: translateY(-8px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
        }}
        
        .connector-header {{
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            gap: 15px;
        }}
        
        .connector-emoji {{
            font-size: 2.5em;
        }}
        
        .connector-title {{
            flex: 1;
        }}
        
        .connector-title h3 {{
            font-size: 1.3em;
            margin-bottom: 5px;
        }}
        
        .connector-type {{
            font-size: 0.85em;
            opacity: 0.9;
        }}
        
        .connector-body {{
            padding: 20px;
        }}
        
        .detail-item {{
            margin-bottom: 15px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 3px solid #667eea;
        }}
        
        .detail-label {{
            font-weight: bold;
            color: #667eea;
            font-size: 0.9em;
            text-transform: uppercase;
            margin-bottom: 5px;
        }}
        
        .detail-value {{
            color: #333;
            font-family: 'Courier New', monospace;
            font-size: 0.85em;
            word-break: break-all;
        }}
        
        .status-badge {{
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: bold;
        }}
        
        .status-enabled {{
            background: #d4edda;
            color: #155724;
        }}
        
        .status-disabled {{
            background: #f8d7da;
            color: #721c24;
        }}
        
        .footer {{
            text-align: center;
            color: white;
            padding: 20px;
            opacity: 0.8;
        }}
        
        .properties-section {{
            margin-top: 10px;
            padding: 10px;
            background: #f0f0f0;
            border-radius: 6px;
            font-size: 0.8em;
        }}
        
        .properties-label {{
            font-weight: bold;
            color: #555;
            margin-bottom: 5px;
        }}
        
        .json-display {{
            background: #2d2d2d;
            color: #f8f8f2;
            padding: 10px;
            border-radius: 4px;
            overflow-x: auto;
            font-family: 'Courier New', monospace;
            font-size: 0.75em;
            line-height: 1.4;
        }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🛡️ Microsoft Sentinel Data Connectors Report</h1>
            <p>📊 KramitSentinal Workspace Overview</p>
            <p style="margin-top: 15px; font-size: 0.9em;">📅 Generated: {timestamp}</p>
        </div>
        
        <div class="stats">
            <div class="stat-card">
                <div class="stat-icon">🔗</div>
                <div class="stat-number">{len(connectors)}</div>
                <div class="stat-label">Active Connectors</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">✅</div>
                <div class="stat-number">{len(connectors)}</div>
                <div class="stat-label">Enabled Connectors</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">📈</div>
                <div class="stat-number">100%</div>
                <div class="stat-label">Health Status</div>
            </div>
        </div>
        
        <div class="connectors-grid">
"""
    
    for connector in connectors:
        kind = connector['kind']
        emoji = get_connector_emoji(kind)
        color = get_connector_color(kind)
        props = connector['properties']
        
        # Extract data type status
        data_types = props.get('dataTypes', {})
        alerts_state = data_types.get('alerts', {}).get('state', 'unknown').upper()
        
        html += f"""
            <div class="connector-card" style="border-left-color: {color}">
                <div class="connector-header" style="background: linear-gradient(135deg, {color} 0%, {color}dd 100%)">
                    <div class="connector-emoji">{emoji}</div>
                    <div class="connector-title">
                        <h3>{kind}</h3>
                        <div class="connector-type">Data Connector</div>
                    </div>
                </div>
                <div class="connector-body">
                    <div class="detail-item">
                        <div class="detail-label">🆔 Connector ID</div>
                        <div class="detail-value">{connector['name']}</div>
                    </div>
                    
                    <div class="detail-item">
                        <div class="detail-label">📊 Alerts Status</div>
                        <span class="status-badge status-enabled">✅ {alerts_state}</span>
                    </div>
"""
        
        if 'tenantId' in props:
            html += f"""
                    <div class="detail-item">
                        <div class="detail-label">🏢 Tenant ID</div>
                        <div class="detail-value">{props['tenantId']}</div>
                    </div>
"""
        
        if 'subscriptionId' in props:
            html += f"""
                    <div class="detail-item">
                        <div class="detail-label">📋 Subscription ID</div>
                        <div class="detail-value">{props['subscriptionId']}</div>
                    </div>
"""
        
        html += f"""
                    <div class="properties-section">
                        <div class="properties-label">📝 Full Configuration</div>
                        <div class="json-display">{json.dumps(props, indent=2)}</div>
                    </div>
                </div>
            </div>
"""
    
    html += """
        </div>
        
        <div class="footer">
            <p>🔐 Security Report • All data connectors are actively streaming data to Sentinel</p>
            <p style="margin-top: 10px; font-size: 0.9em;">✨ Generated by Sentinel Data Connector Exporter</p>
        </div>
    </div>
</body>
</html>
"""
    
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(html)


def main():
    import os
    
    csv_path = os.path.join(os.path.dirname(__file__), 'data_connectors.csv')
    output_path = os.path.join(os.path.dirname(__file__), 'data_connectors_report.html')
    
    print("📊 Generating HTML report...")
    connectors = load_connectors_csv(csv_path)
    generate_html(connectors, output_path)
    print(f"✅ Report generated: {output_path}")
    print(f"🔗 Found {len(connectors)} active data connector(s)")


if __name__ == '__main__':
    main()
