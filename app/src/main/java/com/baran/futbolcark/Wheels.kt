package com.baran.futbolcark.game

import androidx.compose.ui.graphics.Color

object Wheels {

    fun config(type: String, subtitle: String? = null): WheelConfig {
        return when (type) {
            "rating" -> WheelConfig(
                title = "Başlangıç Reytingi",
                buttonText = "Çevir",
                segments = ratingSegments()
            )
            "club" -> WheelConfig(
                title = "Takım",
                buttonText = "Çevir",
                segments = clubSegments()
            )
            "contract" -> WheelConfig(
                title = "Sözleşme Süresi",
                buttonText = "Çevir",
                segments = contractSegments()
            )
            "goals_bundesliga" -> WheelConfig(
                title = "Bundesliga\nGol Sayısı",
                buttonText = "Çevir",
                segments = goalsSegments()
            )
            "transfer" -> WheelConfig(
                title = ((subtitle?.let { "Kalan Sözleşme Süresi: $it\n" } ?: "") + "Transfer"),
                buttonText = "Çevir",
                segments = transferSegments()
            )
            "cup_winner" -> WheelConfig(
                title = "Almanya Kupası",
                buttonText = "Çevir",
                segments = cupWinnerSegments()
            )
            else -> WheelConfig(
                title = "Çark",
                buttonText = "Çevir",
                segments = ratingSegments()
            )
        }
    }

    private fun ratingSegments(): List<WheelSegment> {
        // 60..74, higher = rarer (roughly like the video)
        val base = listOf(
            60 to 0.10f,
            61 to 0.10f,
            62 to 0.10f,
            63 to 0.09f,
            64 to 0.09f,
            65 to 0.08f,
            66 to 0.08f,
            67 to 0.07f,
            68 to 0.07f,
            69 to 0.06f,
            70 to 0.06f,
            71 to 0.05f,
            72 to 0.03f,
            73 to 0.015f,
            74 to 0.005f
        )
        // Yellow/green/red palette
        val colors = listOf(
            Color(0xFFB12A2A), Color(0xFFE04A3A), Color(0xFFE08A2A), Color(0xFFE7D33A), Color(0xFF2B7E52)
        )

        return base.mapIndexed { i, (n, w) ->
            val c = when {
                n <= 63 -> colors[0]
                n <= 66 -> colors[1]
                n <= 69 -> colors[2]
                n <= 72 -> colors[3]
                else -> colors[4]
            }
            val tc = if (c == colors[3]) Color(0xFF101316) else Color.White
            WheelSegment(label = n.toString(), weight = w, color = c, textColor = tc)
        }
    }

    private fun contractSegments(): List<WheelSegment> {
        return listOf(
            WheelSegment("2 Yıl", 0.26f, Color(0xFFB12A2A)),
            WheelSegment("3 Yıl", 0.34f, Color(0xFFE08A2A)),
            WheelSegment("4 Yıl", 0.28f, Color(0xFFE7D33A), textColor = Color(0xFF101316)),
            WheelSegment("5 Yıl", 0.12f, Color(0xFF2B7E52))
        )
    }

    private fun clubSegments(): List<WheelSegment> {
        val red = Color(0xFFB12A2A)
        val yellow = Color(0xFFF2E85C)
        val black = Color(0xFF101316)
        val blue = Color(0xFF1F4EA3)
        val green = Color(0xFF2B7E52)

        return listOf(
            WheelSegment("Bayern Münih", 0.20f, red),
            WheelSegment("Dortmund", 0.14f, yellow, textColor = black),
            WheelSegment("Bayer Leverkusen", 0.12f, black),
            WheelSegment("RB Leipzig", 0.10f, blue),
            WheelSegment("Frankfurt", 0.07f, red),
            WheelSegment("Union Berlin", 0.06f, red),
            WheelSegment("Wolfsburg", 0.05f, green),
            WheelSegment("Freiburg", 0.05f, black),
            WheelSegment("Stuttgart", 0.05f, red),
            WheelSegment("Mainz", 0.04f, red),
            WheelSegment("Hamburg", 0.04f, blue),
            WheelSegment("Köln", 0.03f, red),
            WheelSegment("Werder", 0.03f, green),
            WheelSegment("St Pauli", 0.02f, red),
            WheelSegment("Hoffenheim", 0.02f, blue),
            WheelSegment("Heidenheim", 0.02f, blue),
            WheelSegment("Augsburg", 0.01f, red),
            WheelSegment("M'gladbach", 0.01f, black)
        )
    }

    private fun goalsSegments(): List<WheelSegment> {
        val r = Color(0xFFB12A2A)
        val r2 = Color(0xFFE04A3A)
        val o = Color(0xFFE08A2A)
        val y = Color(0xFFE7D33A)
        val g = Color(0xFF2B7E52)
        val g2 = Color(0xFF3AA05A)
        val darkText = Color(0xFF101316)

        fun seg(label: String, w: Float, c: Color, tc: Color = Color.White) = WheelSegment(label, w, c, tc)

        return listOf(
            seg("0-2", 0.06f, r),
            seg("3-4", 0.06f, r2),
            seg("5-7", 0.08f, r2),
            seg("8-10", 0.10f, r2),
            seg("11", 0.10f, o),
            seg("12", 0.10f, o),
            seg("13", 0.09f, o),
            seg("14", 0.09f, o),
            seg("15", 0.09f, o),
            seg("16", 0.08f, o),
            seg("17", 0.06f, y, darkText),
            seg("18", 0.04f, y, darkText),
            seg("19", 0.03f, y, darkText),
            seg("20", 0.02f, y, darkText),
            seg("21-24", 0.03f, g2),
            seg("25-27", 0.02f, g2),
            seg("28-30", 0.01f, g)
        )
    }

    private fun transferSegments(): List<WheelSegment> {
        val yellow = Color(0xFFF2E85C)
        val green = Color(0xFF2FB55C)
        val purple = Color(0xFF4D148C)
        val darkText = Color(0xFF101316)

        return listOf(
            WheelSegment("Transfer", 0.33f, yellow, darkText),
            WheelSegment("Takımda Kal", 0.55f, green),
            WheelSegment("Sözleşme Uzat", 0.12f, purple)
        )
    }

    private fun cupWinnerSegments(): List<WheelSegment> {
        // Similar to club wheel but even more skewed to top clubs.
        val red = Color(0xFFB12A2A)
        val yellow = Color(0xFFF2E85C)
        val black = Color(0xFF101316)
        val blue = Color(0xFF1F4EA3)
        val green = Color(0xFF2B7E52)

        val small = listOf(
            "Union Berlin" to red,
            "Wolfsburg" to green,
            "Freiburg" to black,
            "Stuttgart" to red,
            "Mainz" to red,
            "Hamburg" to blue,
            "Köln" to red,
            "Werder" to green,
            "St Pauli" to red,
            "Hoffenheim" to blue,
            "Heidenheim" to blue,
            "Augsburg" to red,
            "M'gladbach" to black
        )

        val segs = mutableListOf(
            WheelSegment("Bayern Münih", 0.38f, red),
            WheelSegment("Dortmund", 0.22f, yellow, textColor = black),
            WheelSegment("Bayer Leverkusen", 0.16f, black),
            WheelSegment("RB Leipzig", 0.10f, blue),
        )
        val remain = 1f - segs.sumOf { it.weight.toDouble() }.toFloat()
        val per = remain / small.size
        segs += small.map { (n, c) -> WheelSegment(n, per, c, textColor = if (c == yellow) black else Color.White) }
        return segs
    }
}
