# Yes, yes.  We use powershell on linux.  Get over it.

# Cross platform shebang
shebang := if os() == 'windows' {
  'pwsh.exe'
} else {
  '/usr/bin/env pwsh'
}

# Set the shell for non-Windows OSs
set shell := ["pwsh", "-c"]

# And for Windows
set windows-shell := ["pwsh.exe", "-c"]

# Settings for Godot itself
godot_release := "4.2.2-stable"
godot_platform := if os() == 'windows' {
  "mono_win64"
} else {
  "mono_linux_x86_64"
}
mono_project := "input_buffer_mono"
gdscript_project := "input_buffer_gdscript"

init:
  #!{{shebang}}
  just download-godot


serve-docs:
  #!{{shebang}}
  cd documentation
  pipenv run mkdocs serve
  cd -

download-godot:
  #!{{shebang}}

  # Download the file
  $fileName = "Godot_v{{godot_release}}_{{godot_platform}}.zip"
  Invoke-WebRequest -Uri "https://github.com/godotengine/godot/releases/download/{{godot_release}}/Godot_v{{godot_release}}_{{godot_platform}}.zip" -OutFile $fileName | Out-Null
  $destFolder = "$($PWD)\bin\Godot_v{{godot_release}}_{{godot_platform}}"
  
  # Clean up old builds
  if (Test-Path .\bin) {
    if (Test-Path $destFolder) {
      Remove-Item $destFolder -Force -Recurse -ErrorAction SilentlyContinue | Out-Null
    }
  } else {
    New-Item .\bin -ItemType Directory | Out-Null
  }
  
  Expand-Archive $PWD\$($fileName) -DestinationPath $PWD\bin;
  Remove-Item $fileName;
  if (-Not (Test-Path $destFolder -PathType Container)) {
    New-Item $destFolder -ItemType Directory | Out-Null
    if ($IsWindows) {
      Move-Item ".\bin\Godot*.exe" "$($destFolder)\"
    }
    else {
      Move-Item ".\bin\Godot_v{{godot_release}}_{{godot_platform}}" "$($destFolder)\"
    }
  }
  if ($IsLinux) {
    Move-Item "$($destFolder)\Godot_v*" "$($destFolder)\Godot_v{{godot_release}}_{{godot_platform}}"
  }

open project:
  #!{{shebang}}

  if ($IsWindows) {
    start-process "$($PWD)\bin\Godot_v{{godot_release}}_{{godot_platform}}\Godot_v{{godot_release}}_{{godot_platform}}.exe" -NoNewWindow -UseNewEnvironment -ArgumentList "--editor", "--path", "{{project}}" 2>&1 | Out-Null
  } else {
    start-process "$($PWD)/bin/Godot_v{{godot_release}}_{{godot_platform}}/Godot_v{{godot_release}}_{{godot_platform}}" -NoNewWindow -ArgumentList "--editor", "--path", "{{project}}" 2>&1 | Out-Null
  }

@open-mono:
  just open {{mono_project}}

@open-gdscript:
  just open {{gdscript_project}}

play project:
  #!{{shebang}}

  if ($IsWindows) {
    start-process "$($PWD)\bin\Godot_v{{godot_release}}_{{godot_platform}}\Godot_v{{godot_release}}_{{godot_platform}}.exe" -NoNewWindow -UseNewEnvironment -ArgumentList "--path", "{{project}}" 2>&1 | Out-Null
  } else {
    start-process "$($PWD)/bin/Godot_v{{godot_release}}_{{godot_platform}}/Godot_v{{godot_release}}_{{godot_platform}}" -NoNewWindow -ArgumentList "--path", "{{project}}" 2>&1 | Out-Null
  }

@play-gdscript:
  just play {{gdscript_project}}

@play-mono:
  just play {{mono_project}}