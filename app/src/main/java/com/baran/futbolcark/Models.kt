package com.baran.futbolcark.models

import kotlinx.serialization.Serializable

@Serializable
data class PlayerStats(
    val pace: Int,
    val shot: Int,
    val pass: Int,
    val drib: Int,
    val def: Int,
    val phy: Int
)

@Serializable
data class PlayerProfile(
    val firstName: String,
    val lastName: String,
    val continent: String,
    val country: String,
    val position: Position,
    val jerseyNumber: Int,
    val rating: Int,
    val club: String,
    val contractYears: Int,
    val stats: PlayerStats
) {
    val fullName: String get() = (firstName.trim() + " " + lastName.trim()).trim()
}

@Serializable
enum class Position(val labelTr: String) {
    GK("Kaleci"),
    CB("Stoper"),
    LB("Sol Bek"),
    RB("Sağ Bek"),
    CM("Merkez Orta"),
    CAM("Ofansif Orta"),
    LW("Sol Kanat"),
    RW("Sağ Kanat"),
    ST("Santrafor")
}

@Serializable
data class CareerState(
    val player: PlayerProfile
)

@Serializable
data class DraftPlayer(
    val firstName: String = "Player",
    val lastName: String = "",
    val continent: String = "Avrupa",
    val country: String = "Almanya",
    val position: Position = Position.ST,
    val jerseyNumber: Int = 9,

    val rating: Int? = null,
    val club: String? = null,
    val contractYears: Int? = null
)
