package com.baran.futbolcark.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import com.baran.futbolcark.ui.GlassSurface
import com.baran.futbolcark.ui.ScreenBackground
import com.baran.futbolcark.viewmodel.AppViewModel

@Composable
fun LeagueScreen(vm: AppViewModel) {
    ScreenBackground {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(22.dp)
        ) {
            Text("Lig", style = MaterialTheme.typography.headlineMedium, color = Color.White)
            Spacer(Modifier.height(14.dp))

            GlassSurface(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text("Bundesliga (demo tablo)", style = MaterialTheme.typography.titleLarge, color = Color.White)
                    Spacer(Modifier.height(10.dp))
                    Text("1) Bayern Münih  •  42p", color = Color.White)
                    Text("2) Dortmund     •  39p", color = Color.White)
                    Text("3) Leverkusen   •  37p", color = Color.White)
                    Text("4) RB Leipzig   •  35p", color = Color.White)
                }
            }

            Spacer(Modifier.height(16.dp))

            GlassSurface(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text("Not", style = MaterialTheme.typography.titleLarge, color = Color.White)
                    Spacer(Modifier.height(8.dp))
                    Text(
                        "Bu ekran V0.1 Alpha için iskelet. Videodaki sezon akışı ve istatistikler sonraki adımda genişletilecek.",
                        color = Color.White.copy(alpha = 0.75f)
                    )
                }
            }
        }
    }
}
