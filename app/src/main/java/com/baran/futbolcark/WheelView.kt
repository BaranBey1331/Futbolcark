package com.baran.futbolcark.ui

import android.graphics.Paint
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Rect
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.drawscope.drawIntoCanvas
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.unit.dp
import com.baran.futbolcark.game.WheelSegment
import kotlin.math.PI
import kotlin.math.cos
import kotlin.math.min
import kotlin.math.sin

/**
 * Wheel visual that matches the videos:
 * - Pointer fixed on the right
 * - Segments drawn with thin separators + white outer stroke
 * - Center "ball" icon
 */
@Composable
fun WheelView(
    segments: List<WheelSegment>,
    rotationDeg: Float,
    modifier: Modifier = Modifier
) {
    val textSizePx = with(LocalDensity.current) { 15.dp.toPx() }

    Box(modifier = modifier, contentAlignment = androidx.compose.ui.Alignment.Center) {
        // Wheel itself
        Canvas(
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(1f)
                .graphicsLayer { rotationZ = rotationDeg }
        ) {
            val sizeMin = min(size.width, size.height)
            val pad = sizeMin * 0.04f
            val radius = (sizeMin / 2f) - pad
            val center = Offset(size.width / 2f, size.height / 2f)
            val oval = Rect(
                left = center.x - radius,
                top = center.y - radius,
                right = center.x + radius,
                bottom = center.y + radius
            )

            val total = segments.sumOf { it.weight.toDouble() }.toFloat().coerceAtLeast(0.0001f)
            val startBase = -90f // start at top like in the video
            var start = startBase

            // Draw wedges
            for (seg in segments) {
                val sweep = 360f * (seg.weight / total)
                drawArc(
                    color = seg.color,
                    startAngle = start,
                    sweepAngle = sweep,
                    useCenter = true,
                    topLeft = Offset(oval.left, oval.top),
                    size = oval.size
                )
                // separator line
                drawArc(
                    color = Color.White.copy(alpha = 0.35f),
                    startAngle = start,
                    sweepAngle = sweep,
                    useCenter = true,
                    topLeft = Offset(oval.left, oval.top),
                    size = oval.size,
                    style = androidx.compose.ui.graphics.drawscope.Stroke(width = 1.2f)
                )
                start += sweep
            }

            // Outer ring stroke
            drawCircle(
                color = Color.White.copy(alpha = 0.65f),
                radius = radius,
                center = center,
                style = androidx.compose.ui.graphics.drawscope.Stroke(width = 5f)
            )

            // Labels (radial)
            drawIntoCanvas { canvas ->
                val native = canvas.nativeCanvas
                val p = Paint().apply {
                    isAntiAlias = true
                    textAlign = Paint.Align.CENTER
                    textSize = textSizePx
                    typeface = android.graphics.Typeface.create(android.graphics.Typeface.SANS_SERIF, android.graphics.Typeface.BOLD)
                }

                start = startBase
                for (seg in segments) {
                    val sweep = 360f * (seg.weight / total)
                    val mid = start + sweep / 2f
                    val angleRad = (mid) * (PI / 180.0)
                    val rText = radius * 0.72f
                    val x = center.x + (rText * cos(angleRad)).toFloat()
                    val y = center.y + (rText * sin(angleRad)).toFloat()

                    p.color = seg.textColor.toArgbCompat()

                    native.save()
                    native.translate(x, y)
                    // Rotate text so it's readable along the radius (like the video)
                    native.rotate(mid + 90f)
                    native.drawText(seg.label, 0f, 0f, p)
                    native.restore()

                    start += sweep
                }
            }

            // Center ball (simple)
            drawCircle(color = Color.Black.copy(alpha = 0.75f), radius = radius * 0.10f, center = center)
            drawCircle(color = Color.White, radius = radius * 0.075f, center = center)

            // pentagon-ish
            val poly = Path()
            val pr = radius * 0.045f
            for (i in 0..4) {
                val a = (-90f + i * 72f) * (PI / 180.0)
                val px = center.x + (pr * cos(a)).toFloat()
                val py = center.y + (pr * sin(a)).toFloat()
                if (i == 0) poly.moveTo(px, py) else poly.lineTo(px, py)
            }
            poly.close()
            drawPath(poly, color = Color.Black)
        }

        // Pointer overlay (not rotated)
        Canvas(
            modifier = Modifier
                .fillMaxWidth()
                .aspectRatio(1f)
        ) {
            val sizeMin = min(size.width, size.height)
            val pad = sizeMin * 0.04f
            val radius = (sizeMin / 2f) - pad
            val center = Offset(size.width / 2f, size.height / 2f)

            val tip = Offset(center.x + radius + 6.dp.toPx(), center.y)
            val baseTop = Offset(center.x + radius - 22.dp.toPx(), center.y - 18.dp.toPx())
            val baseBot = Offset(center.x + radius - 22.dp.toPx(), center.y + 18.dp.toPx())

            val pointer = Path().apply {
                moveTo(tip.x, tip.y)
                lineTo(baseTop.x, baseTop.y)
                lineTo(baseBot.x, baseBot.y)
                close()
            }
            drawPath(pointer, color = Color.White)
        }
    }
}

private fun Color.toArgbCompat(): Int {
    return android.graphics.Color.argb(
        (alpha * 255f).toInt(),
        (red * 255f).toInt(),
        (green * 255f).toInt(),
        (blue * 255f).toInt()
    )
}
