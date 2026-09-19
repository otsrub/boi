# GitHub Actions macOS TTS

Generate downloadable speech files on GitHub's macOS 26 runners. No Mac is required.

This is a **batch workflow**, not a live TTS server: start a workflow in GitHub, wait for the macOS job, then download its artifact.

## Limitations

- It can use only voices already installed on GitHub's current `macos-26` runner image.
- Optional Enhanced and Premium voices cannot be installed reliably through Actions because voice installation requires macOS Settings and every hosted job starts on a fresh VM.
- The available voice set can change when GitHub updates its runner image, so run **List macOS Voices** whenever you need the current catalog.
- Review Apple's macOS license for your intended use of system voices and generated output.

## Install the project on GitHub

1. Create a new GitHub repository, such as `mac-actions-tts`.
2. Unzip this project on your computer.
3. Upload the project contents to the repository. The `.github` directory must be included.
4. Open the repository's **Actions** tab. If prompted, enable workflows.

Using Git from a terminal:

```bash
cd github-actions-mac-tts
git init
git add .
git commit -m "Add macOS TTS workflows"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/mac-actions-tts.git
git push -u origin main
```

## Find the installed voices

1. Open **Actions**.
2. Select **List macOS Voices**.
3. Click **Run workflow**, then click the green **Run workflow** button.
4. Open the completed run.
5. In **Artifacts**, download `macos-26-voice-list`.
6. Open `available-voices.txt` and copy the desired voice name exactly.

## Generate speech

1. Open **Actions**.
2. Select **Generate macOS Speech**.
3. Click **Run workflow**.
4. Enter the text.
5. Paste an installed voice name, or leave the voice blank for the runner's default voice.
6. Select AIFF, WAV, or M4A and choose a speaking rate.
7. Run the workflow and wait for it to finish.
8. Open the completed run and download the `macos-speech` artifact.

The artifact contains:

- `speech.aiff`, `speech.wav`, or `speech.m4a`
- `metadata.txt`
- `available-voices.txt`

Artifacts are retained for seven days by the included workflow.

## Common problems

### The requested voice is not found

Run **List macOS Voices** again and copy the voice name exactly. Enhanced/Premium variants shown in macOS documentation may not exist on GitHub's runner.

### The workflow is not visible

Confirm these files exist in the repository's default branch:

```text
.github/workflows/list-voices.yml
.github/workflows/generate-speech.yml
```

### The job fails during conversion

Try AIFF first. AIFF is produced directly by Apple's `say` command; WAV and M4A require `afconvert`.

