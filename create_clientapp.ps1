# Creates a ClientApp React scaffold for the Mission10_Thurman project.
# Usage: .\create_clientapp.ps1
# After running: cd ClientApp; npm install

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$clientApp = Join-Path $scriptRoot 'ClientApp'
$src = Join-Path $clientApp 'src'
$components = Join-Path $src 'components'

Write-Host "Creating directories..."
New-Item -ItemType Directory -Path $clientApp -Force | Out-Null
New-Item -ItemType Directory -Path $src -Force | Out-Null
New-Item -ItemType Directory -Path $components -Force | Out-Null

function Write-File($relativePath, $content) {
    $full = Join-Path $scriptRoot $relativePath
    $dir = Split-Path -Parent $full
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    $content | Out-File -FilePath $full -Encoding utf8 -Force
    Write-Host "Wrote $relativePath"
}

# package.json
Write-File 'ClientApp\package.json' @'
{
  "name": "clientapp",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "vite": "^5.0.0",
    "@vitejs/plugin-react": "^4.0.0"
  }
}
'@

# vite.config.js
Write-File 'ClientApp\vite.config.js' @'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      "/Bowlers": {
        target: "https://localhost:5001",
        secure: false,
        changeOrigin: true
      }
    }
  },
  build: {
    outDir: "../wwwroot/clientapp",
    emptyOutDir: true
  }
});
'@

# index.html
Write-File 'ClientApp\index.html' @'
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Bowlers - ClientApp</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
'@

# src/main.jsx
Write-File 'ClientApp\src\main.jsx' @'
import React from "react";
import { createRoot } from "react-dom/client";
import App from "./App";
import "./index.css";

createRoot(document.getElementById("root")).render(<App />);
'@

# src/App.jsx
Write-File 'ClientApp\src\App.jsx' @'
import React, { useEffect, useState } from "react";
import Heading from "./components/Heading";
import BowlerTable from "./components/BowlerTable";

export default function App() {
  const [bowlers, setBowlers] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch("/Bowlers")
      .then((res) => {
        if (!res.ok) throw new Error(res.statusText);
        return res.json();
      })
      .then((data) => {
        setBowlers(data);
        setLoading(false);
      })
      .catch((err) => {
        setError(err.message);
        setLoading(false);
      });
  }, []);

  return (
    <div className="container py-4">
      <Heading />
      {loading && <p>Loading…</p>}
      {error && <div className="alert alert-danger">Error: {error}</div>}
      {bowlers && <BowlerTable bowlers={bowlers} />}
    </div>
  );
}
'@

# src/components/Heading.jsx
Write-File 'ClientApp\src\components\Heading.jsx' @'
import React from "react";

export default function Heading() {
  return (
    <header className="mb-3">
      <h1 className="h3 mb-1">Bowlers Directory</h1>
      <p className="text-muted mb-3">Showing bowlers who are members of the Marlins or Sharks teams.</p>
    </header>
  );
}
'@

# src/components/BowlerTable.jsx
Write-File 'ClientApp\src\components\BowlerTable.jsx' @'
import React from "react";

export default function BowlerTable({ bowlers }) {
  if (!bowlers || bowlers.length === 0) {
    return <div className="alert alert-info">No bowlers found.</div>;
  }

  return (
    <div className="card">
      <div className="card-body p-0">
        <div className="table-responsive">
          <table className="table table-striped mb-0">
            <thead className="table-light">
              <tr>
                <th>Bowler Name</th>
                <th>Team</th>
                <th>Address</th>
                <th>City</th>
                <th>State</th>
                <th>Zip</th>
                <th>Phone</th>
              </tr>
            </thead>
            <tbody>
              {bowlers.map((b, i) => (
                <tr key={i}>
                  <td>
                    {b.FirstName}
                    {b.Middle ? ` ${b.Middle}.` : ""}
                    {` ${b.LastName}`}
                  </td>
                  <td>{b.Team}</td>
                  <td>{b.Address}</td>
                  <td>{b.City}</td>
                  <td>{b.State}</td>
                  <td>{b.Zip}</td>
                  <td>{b.Phone}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
'@

# src/index.css
Write-File 'ClientApp\src\index.css' @'
body {
  background: #fff;
  color: #212529;
  font-family: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial;
}
'@

Write-Host ""
Write-Host "ClientApp scaffold created."
Write-Host "Next steps:"
Write-Host "  1) cd ClientApp"
Write-Host "  2) npm install"
Write-Host "  3) npm run dev   (dev server proxies /Bowlers to backend)"
Write-Host ""
Write-Host "To create a production build that the ASP.NET app can serve:"
Write-Host "  npm run build  (output -> wwwroot/clientapp)"
Write-Host ""
Write-Host "If your ASP.NET backend uses a different port, edit ClientApp\\vite.config.js proxy target."