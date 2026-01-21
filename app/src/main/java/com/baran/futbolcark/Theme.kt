package com.baran.futbolcark.ui

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val DarkColors = darkColorScheme(
    primary = Color(0xFF7AA7FF),
    secondary = Color(0xFF7DD7C2),
    tertiary = Color(0xFFF2C14E),
    background = Color(0xFF0E1B22),
    surface = Color(0xFF13242D),
    onPrimary = Color.White,
    onSecondary = Color.White,
    onTertiary = Color(0xFF101316),
    onBackground = Color.White,
    onSurface = Color.White
)

@Composable
fun FutbolcarkTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = DarkColors,
        typography = FutbolTypography,
        content = content
    )
}

// Shared "glass" palette used across screens (matching the screenshots)
val kBgTop = Color(0xFF20343C)
val kBgBottom = Color(0xFF0B141A)
val kGlass = Color(0x33FFFFFF)      // translucent fill
val kBorder = Color(0x66FFFFFF)     // translucent border
val kGold = Color(0xFFF0C35A)
val kTextDim = Color(0xCCFFFFFF)
