# 5-Domain Static Launch Pack

This repository hosts five static landing pages, one per domain:

- heylikemagic.com
- askyourcrowd.com
- justaskfolk.com
- bigechochamber.com
- owisewords.com

Current scope is static pages only.

## Repository layout

- `sites.config.json`: domain content configuration
- `templates/index.template.html`: shared HTML template
- `shared/style.css`: shared page styles
- `shared/site.js`: shared client-side script
- `scripts/render-sites.ps1`: generator for all domain folders
- `sites/<domain>/...`: generated static site files for each domain

## Generate all sites

From repository root:

```powershell
.\scripts\render-sites.ps1
```

This command regenerates all `sites/<domain>/index.html` pages and copies shared assets into each domain folder.

## Deploy to Cloudflare Pages

Create one Cloudflare Pages project per domain.

Recommended settings for each project:

- Framework preset: None
- Build command: none
- Build output directory: `sites/<domain>`
- Root directory: repository root

Example output directories:

- `sites/heylikemagic.com`
- `sites/askyourcrowd.com`
- `sites/justaskfolk.com`
- `sites/bigechochamber.com`
- `sites/owisewords.com`

## Attach domains

For each Pages project:

1. Open Custom domains.
2. Add the matching domain.
3. Add `www` if desired.
4. Wait for SSL certificate to issue.

## Spaceship DNS to Cloudflare

If you choose Cloudflare DNS management:

1. Add each domain in Cloudflare.
2. Copy the two Cloudflare nameservers for the domain.
3. In Spaceship, replace current nameservers with Cloudflare nameservers.
4. Wait for propagation.

Notes:

- Moving nameservers is free.
- This does not transfer the registrar.
- Renewal billing remains with Spaceship.