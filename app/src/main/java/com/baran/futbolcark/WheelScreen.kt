package com.baran.futbolcark.screens

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.util.lerp
import com.baran.futbolcark.game.Wheels
import com.baran.futbolcark.game.WheelEngine
import com.baran.futbolcark.game.WheelSegment
import com.baran.futbolcark.ui.GlassSurface
import com.baran.futbolcark.ui.ScreenBackground
import com.baran.futbolcark.ui.SectionTitle
import com.baran.futbolcark.ui.WheelView
import com.baran.futbolcark.ui.WideGlassButton
import com.baran.futbolcark.viewmodel.AppViewModel
import kotlinx.coroutines.launch
import kotlin.math.abs
import kotlin.math.floor
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt
import kotlin.random.Random

@Composable
fun WheelScreen(
    vm: AppViewModel,
    wheelType: String,
    openWheel: (String) -> Unit,
    goHome: () -> Unit,
    onBack: () -> Unit
) {
    val scope = rememberCoroutineScope()
    val draft by vm.draft.collectAsState()
    val career by vm.career.collectAsState()

    val subtitle = when (wheelType) {
        "transfer" -> career?.player?.contractYears?.toString()
        else -> null
    }
    val cfg = remember(wheelType, subtitle) { Wheels.config(wheelType, subtitle) }

    var spinning by remember { mutableStateOf(false) }
    var result by remember { mutableStateOf<WheelSegment?>(null) }
    var rotation by remember { mutableStateOf(0f) }

    fun normalized(deg: Float): Float {
        var d = deg % 360f
        if (d < 0f) d += 360f
        return d
    }

    fun chooseTargetRotation(seg: WheelSegment): Float {
        val total = cfg.segments.sumOf { it.weight.toDouble() }.toFloat().coerceAtLeast(0.0001f)
        val startBase = -90f

        var start = startBase
        var segStart = startBase
        var segSweep = 0f
        for (s in cfg.segments) {
            val sweep = 360f * (s.weight / total)
            if (s == seg) {
                segStart = start
                segSweep = sweep
                break
            }
            start += sweep
        }

        // Pick an angle inside the segment (avoid edges for nicer feel)
        val pad = min(8f, segSweep * 0.15f)
        val targetAngle = segStart + (pad + Random.nextFloat() * max(1f, segSweep - 2 * pad))
        // Pointer is fixed at 0° (3 o'clock). Wheel starts from startBase.
        val want = 360f - normalized(targetAngle) // rotation such that pointer lands on targetAngle
        val extraSpins = (4 + Random.nextInt(4)) * 360f
        return extraSpins + want
    }

    ScreenBackground {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 18.dp, vertical = 18.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Row(Modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
                IconButton(onClick = onBack) { Icon(Icons.Default.ArrowBack, contentDescription = null, tint = Color.White) }
                Spacer(Modifier.width(6.dp))
                SectionTitle(cfg.title)
            }

            Spacer(Modifier.height(6.dp))

            WheelView(
                segments = cfg.segments,
                rotationDeg = rotation,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 10.dp)
            )

            Spacer(Modifier.height(14.dp))

            WideGlassButton(
                text = if (spinning) "Çevriliyor..." else cfg.buttonText,
                icon = Icons.Default.PlayArrow,
                enabled = !spinning
            ) {
                if (spinning) return@WideGlassButton
                spinning = true
                result = null

                val picked = WheelEngine.pickByWeight(cfg.segments)
                val target = chooseTargetRotation(picked)

                scope.launch {
                    val startRot = rotation
                    val durMs = 3600
                    val steps = 60
                    for (i in 1..steps) {
                        val t = i / steps.toFloat()
                        // Smooth deceleration (fast then slow)
                        val eased = cubicOut(t)
                        rotation = startRot + (target * eased)
                        kotlinx.coroutines.delay((durMs / steps).toLong())
                    }
                    rotation = startRot + target
                    result = picked
                    spinning = false
                }
            }

            Spacer(Modifier.height(10.dp))

            AnimatedVisibility(visible = result != null, enter = fadeIn(), exit = fadeOut()) {
                ResultOverlay(
                    wheelType = wheelType,
                    resultText = result?.label.orEmpty(),
                    onRetry = { result = null },
                    onContinue = {
                        val r = result ?: return@ResultOverlay

                        when (wheelType) {
                            "rating" -> {
                                vm.setDraftRating(r.label.toIntOrNull() ?: 65)
                                openWheel("club")
                            }
                            "club" -> {
                                vm.setDraftClub(r.label)
                                openWheel("contract")
                            }
                            "contract" -> {
                                val years = r.label.filter { it.isDigit() }.toIntOrNull() ?: 3
                                vm.setDraftContractYears(years)
                                vm.finalizeCareerIfReady()
                                goHome()
                            }
                            else -> {
                                // informational wheels (goals/transfer/cup winner) -> back
                                onBack()
                            }
                        }
                    }
                )
            }
        }
    }
}

@Composable
private fun ResultOverlay(
    wheelType: String,
    resultText: String,
    onRetry: () -> Unit,
    onContinue: () -> Unit
) {
    GlassSurface(
        modifier = Modifier
            .fillMaxWidth()
            .padding(horizontal = 10.dp),
        corner = 22.dp
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text("Sonuç", style = MaterialTheme.typography.titleLarge, color = Color.White)
            Spacer(Modifier.height(10.dp))
            Text(resultText, style = MaterialTheme.typography.headlineLarge, color = Color.White)
            Spacer(Modifier.height(14.dp))

            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                WideGlassButton(
                    text = "Tekrar",
                    icon = Icons.Default.Refresh,
                    onClick = onRetry,
                    height = 56.dp
                )
                WideGlassButton(
                    text = when (wheelType) {
                        "rating", "club" -> "İlerle"
                        "contract" -> "Başla"
                        else -> "Tamam"
                    },
                    icon = Icons.Default.PlayArrow,
                    onClick = onContinue,
                    height = 56.dp
                )
            }
        }
    }
}

// Cheap, deterministic ease-out (no extra dependency)
private fun cubicOut(t: Float): Float = 1f - (1f - t) * (1f - t) * (1f - t)
