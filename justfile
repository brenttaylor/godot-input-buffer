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
godot_mono := if os() == 'windows' {
  "mono_win64"
} else {
  "mono_linux_x86_64"
}
godot_gdscript := if os() == 'windows' {
  "win64"
} else {
  "linux.x86_64"
}
mono_project := "input_buffer_mono"
gdscript_project := "input_buffer_gdscript"

init:
  #!{{shebang}}
  just download-godot "{{godot_mono}}"
  just download-godot "{{godot_gdscript}}"


serve-docs:
  #!{{shebang}}
  cd documentation
  pipenv run mkdocs serve
  cd -

download-godot godot_platform:
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
  
  New-Item .\tmp -ItemType Directory | Out-Null
  Expand-Archive $PWD\$($fileName) -DestinationPath $PWD\tmp;
  Remove-Item $fileName;
  if (-Not (Test-Path $destFolder -PathType Container)) {
    New-Item $destFolder -ItemType Directory | Out-Null
    if ($IsWindows) {
      Move-Item ".\tmp\Godot*.exe" "$($destFolder)\"
    }
    else {
      if (Test-Path ".\tmp\Godot_v{{godot_release}}_{{godot_platform}}" -PathType Leaf) {
        Move-Item ".\tmp\Godot_v{{godot_release}}_{{godot_platform}}" "$($destFolder)\"
      } else {
        Move-Item ".\tmp\Godot_v{{godot_release}}_{{godot_platform}}\*" "$($destFolder)\" 
      }
    }
  }

  Remove-Item $PWD\tmp -Force -Recurse -ErrorAction SilentlyContinue | Out-Null

open project godot_platform:
  #!{{shebang}}
  $gdDir = "$($PWD)/bin/Godot_v{{godot_release}}_{{godot_platform}}/"
  $gdBin = (get-childitem $gdDir/Godot_v{{godot_release}}*)[0] | select -expand FullName

  if ($IsWindows) {
    start-process "$($gdDir)\Godot_v{{godot_release}}_{{godot_platform}}.exe" -NoNewWindow -UseNewEnvironment -ArgumentList "--editor", "--path", "{{project}}" 2>&1 | Out-Null
  } else {
    start-process $gdBin -NoNewWindow -ArgumentList "--editor", "--path", "{{project}}" 2>&1 | Out-Null
  }

@open-mono:
  just open {{mono_project}} {{godot_mono}}

@open-gdscript:
  just open {{gdscript_project}} {{godot_gdscript}}

play project godot_platform:
  #!{{shebang}}
  $gdDir = "$($PWD)/bin/Godot_v{{godot_release}}_{{godot_platform}}/"
  $gdBin = (get-childitem $gdDir/Godot_v{{godot_release}}*)[0] | select -expand Name
  
  if ($IsWindows) {
    start-process "$($gdDir)\Godot_v{{godot_release}}_{{godot_platform}}.exe" -NoNewWindow -UseNewEnvironment -ArgumentList "--path", "{{project}}" 2>&1 | Out-Null
  } else {
    start-process $gdDir/$gdBin -NoNewWindow -ArgumentList "--path", "{{project}}" 2>&1 | Out-Null
  }

@play-gdscript:
  just play {{gdscript_project}} {{godot_gdscript}}

@play-mono:
  just play {{mono_project}} {{godot_mono}}

@build release:
  #!{{shebang}}
  $gdDir = "$($PWD)/bin/Godot_v{{godot_release}}_{{godot_gdscript}}/"
  $gdBin = (get-childitem $gdDir/Godot_v{{godot_release}}*)[0] | select -expand Name 
  $buildDir = "$($PWD)/build/BufferedInput_{{release}}_for_Godot_{{godot_release}}"

  if (Test-Path $PWD/build -PathType Container) {
    rm -rf $PWD/build 
  }
  if (Test-Path $PWD/release -PathType Container) {
    rm -rf $PWD/release
  }
  New-Item $PWD/release -ItemType Directory | Out-Null
  New-Item $PWD/build -ItemType Directory | Out-Null
  New-Item $PWD/build/web -ItemType Directory | Out-Null
  New-Item $buildDir -ItemType Directory | Out-Null
  New-Item $buildDir/BufferedInput -ItemType Directory | Out-Null
  
  # Build the web export for Itch
  .$gdDir/$gdBin --headless --path {{gdscript_project}} --export-release itchio $PWD/build/web/index.html
  Compress-Archive -Path $PWD/build/web/* -DestinationPath $PWD/release/itch_web_BufferedInput_{{release}}_for_Godot_{{godot_release}}.zip

  # Build release
  cp $PWD/LICENSE $buildDir/LICENSE
  cp $PWD/README.md $buildDir/README.md
  cp $PWD/{{gdscript_project}}/buffered_input/buffered_input.gd $buildDir/BufferedInput/buffered_input.gd
  cp $PWD/{{mono_project}}/buffered_input/BufferedInput.cs $buildDir/BufferedInput/BufferedInput.cs
  Compress-Archive -LiteralPath $buildDir -DestinationPath $PWD/release/BufferedInput_{{release}}_for_Godot_{{godot_release}}.zip

  rm -rf $PWD/build
