package com.baran.futbolcark

import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.EmojiEvents
import androidx.compose.material.icons.filled.Groups
import androidx.compose.material.icons.filled.Person
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.compose.*
import com.baran.futbolcark.data.CareerRepository
import com.baran.futbolcark.data.careerStore
import com.baran.futbolcark.screens.*
import com.baran.futbolcark.ui.FutbolcarkTheme
import com.baran.futbolcark.viewmodel.AppViewModel
import com.baran.futbolcark.viewmodel.AppViewModelFactory

private sealed class Tab(val route: String, val label: String, val icon: @Composable () -> Unit) {
    data object Squad : Tab("tab_squad", "Kart ve Kadro", { Icon(Icons.Filled.Groups, null) })
    data object Career : Tab("tab_career", "Kariyer", { Icon(Icons.Filled.Person, null) })
    data object League : Tab("tab_league", "Lig", { Icon(Icons.Filled.EmojiEvents, null) })
    data object Edit : Tab("tab_edit", "Düzenle", { Icon(Icons.Filled.Edit, null) })
}

@Composable
fun FutbolcarkApp() {
    FutbolcarkTheme {
        val appContext = LocalContext.current
        val repo = remember { CareerRepository(appContext.careerStore) }
        val vm: AppViewModel = viewModel(factory = AppViewModelFactory(repo))

        val navController = rememberNavController()
        val tabs = remember { listOf(Tab.Squad, Tab.Career, Tab.League, Tab.Edit) }

        Scaffold(
            bottomBar = {
                NavigationBar {
                    val backStack by navController.currentBackStackEntryAsState()
                    val current = backStack?.destination?.route
                    tabs.forEach { tab ->
                        NavigationBarItem(
                            selected = current == tab.route,
                            onClick = {
                                navController.navigate(tab.route) {
                                    popUpTo(navController.graph.findStartDestination().id) {
                                        saveState = true
                                    }
                                    launchSingleTop = true
                                    restoreState = true
                                }
                            },
                            icon = tab.icon,
                            label = { Text(tab.label) }
                        )
                    }
                }
            }
        ) { inner ->
            NavHost(
                navController = navController,
                startDestination = Tab.Career.route,
                modifier = Modifier.padding(inner)
            ) {
                composable(Tab.Squad.route) { SquadScreen(vm) }
                composable(Tab.Career.route) {
                    CareerScreen(
                        vm = vm,
                        openCreate = { navController.navigate("create_player") },
                        openWheel = { navController.navigate("wheel/$it") }
                    )
                }
                composable(Tab.League.route) { LeagueScreen(vm) }
                composable(Tab.Edit.route) { EditScreen(vm) }

                composable("create_player") {
                    CreatePlayerScreen(
                        vm = vm,
                        onDone = { navController.popBackStack() },
                        openWheel = { navController.navigate("wheel/$it") }
                    )
                }
                composable("wheel/{type}") { entry ->
                    val type = entry.arguments?.getString("type") ?: "rating"
                    WheelScreen(
                        vm = vm,
                        wheelType = type,
                        openWheel = { navController.navigate("wheel/$it") },
                        goHome = {
                            navController.navigate(Tab.Career.route) {
                                popUpTo(navController.graph.findStartDestination().id) { inclusive = false }
                                launchSingleTop = true
                            }
                        },
                        onBack = { navController.popBackStack() }
                    )
                }
            }
        }
    }
}
