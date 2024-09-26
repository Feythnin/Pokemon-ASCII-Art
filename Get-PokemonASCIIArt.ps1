###########################################################################
# A fun expiriment to see if I could get ascii art from an image.         #
# Written by: Feythnin 9/25/2024                                          #
#                                                                         #
# Convert-ImagetoAscii module by: https://github.com/tobiohlala/Asciify   #
# Thank you to PokemonAPI for the images                                  #
#                                                                         #
# ENJOY!                                                                  #
###########################################################################

# Define parameters
# spritePosition only takes a specific input and that was put into a validateset
# Pokemon is a string that needs to have a valid pokemon name entered

param(
    [Parameter()]
    [ValidateSet('back_default', 'back_female', 'back_shiny', 'back_shiny_female', 'front_default', 'front_female', 'front_shiny', 'front_shiny_female')]
    [string]$spritePosition,
    [string]$pokemon,
    $imagePath = "$pokemon.png"
)

# Install and import needed modules

Install-Module -Name Asciify
Install-Module -Name Asciify

# Since the list of pokemon is too long to fit in an array (go on, try it, I dare you), this will get the webpage and return an error if invalid pokemon

try {
    $sprites = Invoke-RestMethod -method GET -uri https://pokeapi.co/api/v2/pokemon/$pokemon | Select-Object -expandProperty sprites -ErrorAction Stop
}
catch [System.Net.WebException] {
    Write-Host "That pokemon does not exist."
    exit
}

# Grab the sprite for the pokemon and position chosen

$pictureChosen = $sprites.$spritePosition

# Grab the png and store it in the imagePath var

Invoke-WebRequest -Uri $pictureChosen -OutFile $imagePath

# Finally, convert the image to Ascii

Convert-ImageToAscii $imagePath