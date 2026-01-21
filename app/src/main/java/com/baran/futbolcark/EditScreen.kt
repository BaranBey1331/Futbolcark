package com.baran.futbolcark.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import com.baran.futbolcark.ui.ScreenBackground
import com.baran.futbolcark.viewmodel.AppViewModel

@Composable
fun EditScreen(vm: AppViewModel) {
    ScreenBackground {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(22.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Text("Düzenle", style = MaterialTheme.typography.headlineMedium, color = Color.White)
            Spacer(Modifier.height(10.dp))
            Text("V0.1 Alpha: düzenleme/ayarlar sonraki sürüm.", color = Color.White.copy(alpha = 0.75f))
        }
    }
}
