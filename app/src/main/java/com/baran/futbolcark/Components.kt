package com.baran.futbolcark.ui

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp

@Composable
fun ScreenBackground(content: @Composable BoxScope.() -> Unit) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(
                Brush.linearGradient(
                    colors = listOf(kBgTop, kBgBottom)
                )
            ),
        content = content
    )
}

@Composable
fun GlassSurface(
    modifier: Modifier = Modifier,
    corner: Dp = 22.dp,
    fill: Color = kGlass,
    border: Color = kBorder,
    content: @Composable ColumnScope.() -> Unit
) {
    Surface(
        modifier = modifier,
        color = fill,
        shape = RoundedCornerShape(corner),
        border = BorderStroke(1.2.dp, border)
    ) {
        Column(content = content)
    }
}

@Composable
fun WideGlassButton(
    text: String,
    icon: ImageVector? = null,
    enabled: Boolean = true,
    height: Dp = 64.dp,
    onClick: () -> Unit
) {
    val fg = if (enabled) Color.White else Color.White.copy(alpha = 0.35f)
    val br = if (enabled) kBorder else Color.White.copy(alpha = 0.15f)

    Box(
        modifier = Modifier
            .fillMaxWidth()
            .height(height)
            .clip(RoundedCornerShape(28.dp))
            .border(1.2.dp, br, RoundedCornerShape(28.dp))
            .background(kGlass)
            .clickable(
                enabled = enabled,
                indication = null,
                interactionSource = remember { MutableInteractionSource() }
            ) { onClick() },
        contentAlignment = Alignment.Center
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            if (icon != null) {
                Icon(icon, contentDescription = null, tint = fg)
                Spacer(Modifier.width(12.dp))
            }
            Text(
                text = text,
                style = MaterialTheme.typography.titleLarge,
                color = fg
            )
        }
    }
}

@Composable
fun SectionTitle(text: String) {
    Text(
        text = text,
        style = MaterialTheme.typography.headlineMedium,
        color = Color.White,
        modifier = Modifier.padding(vertical = 10.dp)
    )
}

@Composable
fun StatTile(
    value: Int,
    label: String,
    icon: ImageVector? = null,
    modifier: Modifier = Modifier
) {
    GlassSurface(
        modifier = modifier
            .height(86.dp)
            .padding(0.dp),
        corner = 16.dp
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 16.dp, vertical = 10.dp),
            verticalArrangement = Arrangement.Center
        ) {
            Text(
                text = value.toString(),
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold,
                color = Color.White
            )
            Spacer(Modifier.height(6.dp))
            Row(verticalAlignment = Alignment.CenterVertically) {
                if (icon != null) {
                    Icon(icon, contentDescription = null, tint = kTextDim)
                    Spacer(Modifier.width(8.dp))
                }
                Text(
                    text = label,
                    style = MaterialTheme.typography.titleMedium,
                    color = kTextDim
                )
            }
        }
    }
}

@Composable
fun Pill(text: String) {
    Box(
        modifier = Modifier
            .clip(RoundedCornerShape(18.dp))
            .background(Color.White.copy(alpha = 0.15f))
            .padding(horizontal = 18.dp, vertical = 10.dp)
    ) {
        Text(text = text, color = Color.White, style = MaterialTheme.typography.titleLarge)
    }
}
