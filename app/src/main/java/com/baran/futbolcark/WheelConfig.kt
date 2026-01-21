package com.baran.futbolcark.game

import androidx.compose.ui.graphics.Color

data class WheelSegment(
    val label: String,
    val weight: Float,
    val color: Color,
    val textColor: Color = Color.White
)

data class WheelConfig(
    val title: String,
    val buttonText: String = "Çevir",
    val segments: List<WheelSegment>
)
