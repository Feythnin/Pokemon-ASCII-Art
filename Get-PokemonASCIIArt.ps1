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

<#
.SYNOPSIS
    Takes the entered pokemon and sprite position and outputs an ASCII version of that sprite.

.DESCRIPTION
    Starts off by finding the pokemon entered in the PokeAPI database. Also takes the sprite position that you want to output.
    If the pokemon doesn't exist, it will output as such.
    If the sprite position chosen does not exist for the pokemon, it will output that as well.
    If everything matches correctly, the sprite will output as an ASCII picture.

.PARAMETER pokemon
    Takes any valid pokemon, ie. Bulbasaur. A list of pokemon can be found on Bulbapedia.com. 

.PARAMETER spritePosition
    Takes the following strings: back_default, back_female, front_default, front_female

.EXAMPLE
    Get-PokemonASCIIArt.ps1 -pokemon Bulbasaur -spritePosition front_female

    Does something. Have as many examples as you think useful.
#>


param(
    [Parameter(mandatory = $true)]
    [ValidateSet('back_default', 'back_female', 'front_default', 'front_female')]
    [string]$spritePosition,
    [Parameter(mandatory = $true)]
    [string]$pokemon
)

$imagePath = "c:\windows\temp\$pokemon.png"

# Install and import needed modules

Install-Module -Name Asciify -scope CurrentUser
Import-Module -Name Asciify

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
# If that pokemon doesn't have that sprite position, output error

try {
    Invoke-WebRequest -Uri $pictureChosen -OutFile $imagePath -ErrorAction Stop
}
catch [System.Management.Automation.ParameterBindingException] {
    Write-Output "Unfortunately, there is no sprite for that position"
    exit
}

# Finally, convert the image to Ascii

Convert-ImageToAscii $imagePath