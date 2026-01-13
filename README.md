# Private File Hosting

This repository provides a simple static file hosting service for distributing agent installer files via Cloudflare Pages.

## Purpose

This is a **private file hosting service** for personal use, allowing you to upload and share installer files with friends. Files are hosted on Cloudflare Pages and can be accessed via direct download links.

## Architecture

- **Hosting**: Cloudflare Pages
- **Domain**: agent.jezlol.xyz
- **Type**: Static website (no server-side processing)
- **Authentication**: None required (public file hosting)
- **Use Case**: Personal file sharing for agent installer distribution

## Structure

```
.
├── index.html              # Main file listing page
├── upload.html             # Instructions for uploading files
├── installer_output/       # Installer files directory
│   ├── install.bat
│   ├── uninstall.bat
│   └── app/               # Application files
├── checksums.txt           # SHA-256 checksums for verification
├── robots.txt              # Search engine directives
├── _headers                # Cloudflare Pages security headers
├── README.md               # This file
└── .well-known/
    └── security.txt        # Security contact information
```

## How It Works

1. **Upload Files**: Upload files to this GitHub repository (via web interface or git)
2. **Auto-Deploy**: Cloudflare Pages automatically detects changes and deploys
3. **Access Files**: Files become available at `https://agent.jezlol.xyz/[path/to/file]`
4. **Share Links**: Share direct download links with friends

## File Upload

### Via GitHub Web Interface (Recommended)

1. Go to: `https://github.com/thanaparnjezlol-web/agent_upload`
2. Click "Add file" → "Upload files"
3. Drag and drop files or browse
4. Commit changes
5. Wait 1-2 minutes for Cloudflare Pages to deploy

See `upload.html` for detailed instructions.

### Via Git Command Line

```bash
git add .
git commit -m "Add new files"
git push
```

## File Access

After uploading, files are accessible at:
- `https://agent.jezlol.xyz/[path/to/file]`

Examples:
- `https://agent.jezlol.xyz/installer_output/install.bat`
- `https://agent.jezlol.xyz/installer_output/app/MonitorAgent-Service.exe`

## File Descriptions

### index.html
Main file listing page that displays all available files with download links.

### upload.html
Step-by-step instructions for uploading files to the repository.

### installer_output/
Directory containing the agent installer package:
- `install.bat` - Installation script
- `uninstall.bat` - Uninstallation script
- `app/` - Application executables and files

### checksums.txt
SHA-256 checksums for file integrity verification.

### _headers
Cloudflare Pages security headers configuration.

## Deployment

This site is deployed automatically via Cloudflare Pages:

1. Push changes to the repository
2. Cloudflare Pages detects the changes
3. The static site is built and deployed (no build step required)
4. Files are available at agent.jezlol.xyz

## Security Considerations

- Files are publicly accessible (no authentication)
- **Do not upload sensitive information or secrets**
- HTTPS is enforced by Cloudflare
- Security headers are configured via `_headers`
- Security contact information is available via security.txt

## Maintenance

### To Add New Files:
1. Upload files to the repository (via GitHub web or git)
2. Update `index.html` to add download links (optional, for better UX)
3. Commit and push changes
4. Cloudflare Pages will automatically redeploy

### To Update Existing Files:
1. Replace the file in the repository
2. Commit and push changes
3. Cloudflare Pages will automatically redeploy

## Usage Notes

- **File Size Limits**: Check Cloudflare Pages limits for large files
- **Deployment Time**: Changes typically appear within 1-2 minutes
- **Folder Structure**: Maintain folder structure when uploading (e.g., `installer_output/app/`)
- **Direct Links**: Files can be accessed via direct URLs without visiting index.html

## License

This file hosting service is for personal use. Please refer to the project documentation for licensing information regarding the agent software.
