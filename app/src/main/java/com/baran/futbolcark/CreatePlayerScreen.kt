package com.baran.futbolcark.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Badge
import androidx.compose.material.icons.filled.Image
import androidx.compose.material.icons.filled.Shield
import androidx.compose.material.icons.filled.SportsSoccer
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.input.KeyboardOptions
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import com.baran.futbolcark.models.Position
import com.baran.futbolcark.ui.*
import com.baran.futbolcark.viewmodel.AppViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CreatePlayerScreen(
    vm: AppViewModel,
    onDone: () -> Unit,
    openWheel: (String) -> Unit
) {
    val d by vm.draft.collectAsState()

    val continents = listOf("Avrupa", "Asya", "Afrika", "Kuzey Amerika", "Güney Amerika", "Okyanusya")
    val countries = listOf("Almanya", "Türkiye", "İngiltere", "İspanya", "Fransa", "İtalya", "Portekiz", "Hollanda")
    val positions = Position.values().toList()

    var continentExpanded by remember { mutableStateOf(false) }
    var countryExpanded by remember { mutableStateOf(false) }
    var posExpanded by remember { mutableStateOf(false) }

    ScreenBackground {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(22.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            SectionTitle("Oyuncu Oluştur")

            // 2x2 quick tiles like the video
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                Tile(icon = Icons.Default.Badge, text = "Oyuncu Kartı", modifier = Modifier.weight(1f))
                Tile(icon = Icons.Default.SportsSoccer, text = "Saha", modifier = Modifier.weight(1f))
            }
            Spacer(Modifier.height(10.dp))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                Tile(icon = Icons.Default.Shield, text = "Hedef", modifier = Modifier.weight(1f))
                Tile(icon = Icons.Default.Image, text = "Fotoğraf", modifier = Modifier.weight(1f))
            }

            Spacer(Modifier.height(14.dp))

            GlassSurface(modifier = Modifier.fillMaxWidth()) {
                Column(modifier = Modifier.padding(14.dp)) {

                    OutlinedTextField(
                        value = d.firstName,
                        onValueChange = { vm.updateDraft(firstName = it) },
                        label = { Text("Ad") },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth(),
                        colors = textFieldColors()
                    )
                    Spacer(Modifier.height(10.dp))
                    OutlinedTextField(
                        value = d.lastName,
                        onValueChange = { vm.updateDraft(lastName = it) },
                        label = { Text("Soyad") },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth(),
                        colors = textFieldColors()
                    )

                    Spacer(Modifier.height(10.dp))

                    ExposedDropdownMenuBox(
                        expanded = continentExpanded,
                        onExpandedChange = { continentExpanded = !continentExpanded }
                    ) {
                        OutlinedTextField(
                            readOnly = true,
                            value = d.continent,
                            onValueChange = {},
                            label = { Text("Kıta") },
                            trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = continentExpanded) },
                            modifier = Modifier
                                .fillMaxWidth()
                                .menuAnchor(),
                            colors = textFieldColors()
                        )
                        ExposedDropdownMenu(expanded = continentExpanded, onDismissRequest = { continentExpanded = false }) {
                            continents.forEach { c ->
                                DropdownMenuItem(
                                    text = { Text(c) },
                                    onClick = {
                                        vm.updateDraft(continent = c)
                                        continentExpanded = false
                                    }
                                )
                            }
                        }
                    }

                    Spacer(Modifier.height(10.dp))

                    ExposedDropdownMenuBox(
                        expanded = countryExpanded,
                        onExpandedChange = { countryExpanded = !countryExpanded }
                    ) {
                        OutlinedTextField(
                            readOnly = true,
                            value = d.country,
                            onValueChange = {},
                            label = { Text("Ülke") },
                            trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = countryExpanded) },
                            modifier = Modifier
                                .fillMaxWidth()
                                .menuAnchor(),
                            colors = textFieldColors()
                        )
                        ExposedDropdownMenu(expanded = countryExpanded, onDismissRequest = { countryExpanded = false }) {
                            countries.forEach { c ->
                                DropdownMenuItem(
                                    text = { Text(c) },
                                    onClick = {
                                        vm.updateDraft(country = c)
                                        countryExpanded = false
                                    }
                                )
                            }
                        }
                    }

                    Spacer(Modifier.height(10.dp))

                    ExposedDropdownMenuBox(
                        expanded = posExpanded,
                        onExpandedChange = { posExpanded = !posExpanded }
                    ) {
                        OutlinedTextField(
                            readOnly = true,
                            value = d.position.labelTr,
                            onValueChange = {},
                            label = { Text("Pozisyon") },
                            trailingIcon = { ExposedDropdownMenuDefaults.TrailingIcon(expanded = posExpanded) },
                            modifier = Modifier
                                .fillMaxWidth()
                                .menuAnchor(),
                            colors = textFieldColors()
                        )
                        ExposedDropdownMenu(expanded = posExpanded, onDismissRequest = { posExpanded = false }) {
                            positions.forEach { p ->
                                DropdownMenuItem(
                                    text = { Text(p.labelTr) },
                                    onClick = {
                                        vm.updateDraft(position = p)
                                        posExpanded = false
                                    }
                                )
                            }
                        }
                    }

                    Spacer(Modifier.height(10.dp))

                    OutlinedTextField(
                        value = d.jerseyNumber.toString(),
                        onValueChange = {
                            val v = it.filter { ch -> ch.isDigit() }.take(2)
                            vm.updateDraft(jerseyNumber = v.toIntOrNull() ?: 9)
                        },
                        label = { Text("Forma Numarası") },
                        singleLine = true,
                        modifier = Modifier.fillMaxWidth(),
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                        colors = textFieldColors()
                    )

                    Spacer(Modifier.height(16.dp))

                    WideGlassButton(
                        text = "İlerle",
                        icon = Icons.Default.SportsSoccer
                    ) {
                        // Start the wheel flow (rating -> club -> contract)
                        openWheel("rating")
                    }
                }
            }
        }
    }
}

@Composable
private fun Tile(icon: androidx.compose.ui.graphics.vector.ImageVector, text: String, modifier: Modifier = Modifier) {
    GlassSurface(modifier = modifier.height(86.dp), corner = 16.dp) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(12.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Icon(icon, contentDescription = null, tint = Color.White)
            Spacer(Modifier.height(8.dp))
            Text(text, color = kTextDim, style = MaterialTheme.typography.bodyMedium)
        }
    }
}

@Composable
private fun textFieldColors() = OutlinedTextFieldDefaults.colors(
    focusedBorderColor = kBorder,
    unfocusedBorderColor = Color.White.copy(alpha = 0.20f),
    focusedLabelColor = Color.White,
    unfocusedLabelColor = kTextDim,
    focusedTextColor = Color.White,
    unfocusedTextColor = Color.White,
    cursorColor = Color.White,
    focusedContainerColor = kGlass,
    unfocusedContainerColor = kGlass
)
