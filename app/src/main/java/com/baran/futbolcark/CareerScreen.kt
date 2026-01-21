package com.baran.futbolcark.screens

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material.icons.filled.SportsSoccer
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.Fill
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.baran.futbolcark.models.CareerState
import com.baran.futbolcark.ui.*
import com.baran.futbolcark.viewmodel.AppViewModel

@Composable
fun CareerScreen(
    vm: AppViewModel,
    openCreate: () -> Unit,
    openWheel: (String) -> Unit
) {
    val career by vm.career.collectAsState()
    ScreenBackground {
        StadiumBackdrop()

        if (career == null) {
            StartHome(
                onNewCareer = {
                    vm.newDraft()
                    openCreate()
                }
            )
        } else {
            CareerHome(
                career = career!!,
                onBundesliga = { openWheel("goals_bundesliga") },
                onLeagueWheel = { openWheel("transfer") },
                onReset = { vm.clearCareer() }
            )
        }
    }
}

@Composable
private fun StadiumBackdrop() {
    Canvas(modifier = Modifier.fillMaxSize()) {
        // simple stadium-ish vignette + lights
        drawRect(Color.Black.copy(alpha = 0.22f))
        val w = size.width
        val h = size.height

        // top glow
        drawCircle(
            color = Color.White.copy(alpha = 0.06f),
            radius = w * 0.9f,
            center = androidx.compose.ui.geometry.Offset(w * 0.5f, h * -0.1f),
            style = Fill
        )

        // "pitch" glow bottom
        drawCircle(
            color = Color(0xFF2FB55C).copy(alpha = 0.09f),
            radius = w * 0.95f,
            center = androidx.compose.ui.geometry.Offset(w * 0.5f, h * 1.05f),
            style = Fill
        )
    }
}

@Composable
private fun StartHome(onNewCareer: () -> Unit) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 22.dp, vertical = 26.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(Modifier.height(22.dp))
        Text(
            text = "FUTBOL ÇARK",
            style = MaterialTheme.typography.headlineLarge,
            fontWeight = FontWeight.Bold,
            color = Color.White
        )
        Spacer(Modifier.height(8.dp))
        Text(
            text = "Kariyer çarkı oyunu",
            style = MaterialTheme.typography.titleMedium,
            color = kTextDim
        )

        Spacer(Modifier.height(34.dp))

        GlassSurface(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(18.dp)) {
                Text("Yeni Kariyer", style = MaterialTheme.typography.titleLarge, color = Color.White)
                Spacer(Modifier.height(10.dp))
                Text(
                    "Oyuncunu oluştur, çarkları çevir ve kariyerine başla.",
                    style = MaterialTheme.typography.bodyMedium,
                    color = kTextDim
                )
                Spacer(Modifier.height(18.dp))
                WideGlassButton(text = "Yeni Kariyer", icon = Icons.Default.PlayArrow, onClick = onNewCareer)
            }
        }

        Spacer(Modifier.height(18.dp))

        GlassSurface(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(18.dp)) {
                Text("Devam Et", style = MaterialTheme.typography.titleLarge, color = Color.White)
                Spacer(Modifier.height(10.dp))
                Text(
                    "Kayıtlı bir kariyer yoksa bu buton pasif kalır.",
                    style = MaterialTheme.typography.bodyMedium,
                    color = kTextDim
                )
                Spacer(Modifier.height(18.dp))
                WideGlassButton(text = "Devam Et", enabled = false, icon = Icons.Default.Refresh, onClick = {})
            }
        }
    }
}

@Composable
private fun CareerHome(
    career: CareerState,
    onBundesliga: () -> Unit,
    onLeagueWheel: () -> Unit,
    onReset: () -> Unit
) {
    val p = career.player

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(horizontal = 22.dp, vertical = 22.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(Modifier.height(6.dp))

        // Rating badge + name (similar to the screenshot)
        GlassSurface(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(18.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                RatingBadge(p.rating)
                Spacer(Modifier.height(12.dp))
                Text(p.fullName.uppercase(), style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
                Spacer(Modifier.height(8.dp))
                Pill("${p.position.labelTr} • #${p.jerseyNumber}")
                Spacer(Modifier.height(8.dp))
                Text(p.club, style = MaterialTheme.typography.titleMedium, color = kTextDim)
                Spacer(Modifier.height(4.dp))
                Text("Sözleşme: ${p.contractYears} Yıl", style = MaterialTheme.typography.bodyMedium, color = kTextDim)
            }
        }

        Spacer(Modifier.height(14.dp))

        // Stats grid
        Column(modifier = Modifier.fillMaxWidth()) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                StatTile(value = p.stats.pace, label = "HIZ", icon = Icons.Default.SportsSoccer, modifier = Modifier.weight(1f))
                StatTile(value = p.stats.shot, label = "ŞUT", icon = Icons.Default.SportsSoccer, modifier = Modifier.weight(1f))
            }
            Spacer(Modifier.height(10.dp))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                StatTile(value = p.stats.pass, label = "PAS", icon = Icons.Default.SportsSoccer, modifier = Modifier.weight(1f))
                StatTile(value = p.stats.drib, label = "DRI", icon = Icons.Default.SportsSoccer, modifier = Modifier.weight(1f))
            }
            Spacer(Modifier.height(10.dp))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                StatTile(value = p.stats.def, label = "DEF", icon = Icons.Default.SportsSoccer, modifier = Modifier.weight(1f))
                StatTile(value = p.stats.phy, label = "FİZ", icon = Icons.Default.SportsSoccer, modifier = Modifier.weight(1f))
            }
        }

        Spacer(Modifier.height(16.dp))

        WideGlassButton(text = "Bundesliga", icon = Icons.Default.SportsSoccer, onClick = onBundesliga)
        Spacer(Modifier.height(12.dp))
        WideGlassButton(text = "Lig Çarkı", icon = Icons.Default.Refresh, onClick = onLeagueWheel)

        Spacer(Modifier.weight(1f))

        WideGlassButton(text = "Kariyeri Sıfırla", icon = Icons.Default.Refresh, onClick = onReset, height = 56.dp)
        Spacer(Modifier.height(8.dp))
    }
}

@Composable
private fun RatingBadge(rating: Int) {
    Box(contentAlignment = Alignment.Center) {
        Canvas(modifier = Modifier.size(92.dp)) {
            drawCircle(color = kGold.copy(alpha = 0.18f))
            drawCircle(color = kGold, style = androidx.compose.ui.graphics.drawscope.Stroke(width = 6f))
        }
        Text(rating.toString(), style = MaterialTheme.typography.headlineLarge, fontWeight = FontWeight.Bold, color = Color.White)
    }
}
