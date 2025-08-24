# clear the state of run_onchange_ scripts
chezmoi state delete-bucket --bucket=entryState

# clear state of run_once_ scripts
chezmoi state delete-bucket --bucket=scriptState
