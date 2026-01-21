package com.baran.futbolcark.game

import com.baran.futbolcark.models.PlayerStats
import com.baran.futbolcark.models.Position
import kotlin.math.max
import kotlin.math.min
import kotlin.random.Random

object WheelEngine {

    fun pickByWeight(segments: List<WheelSegment>, rng: Random = Random.Default): WheelSegment {
        val total = segments.sumOf { it.weight.toDouble() }.toFloat().coerceAtLeast(0.0001f)
        val r = rng.nextFloat() * total
        var acc = 0f
        for (s in segments) {
            acc += s.weight
            if (r <= acc) return s
        }
        return segments.last()
    }

    fun clampStat(v: Int): Int = min(99, max(30, v))

    fun makeStats(ovr: Int, pos: Position, rng: Random = Random.Default): PlayerStats {
        // Position bias (approximate FIFA-like feel, matching the video "vibe")
        val bias = when (pos) {
            Position.GK -> Bias(pace = -10, shot = -30, pass = -10, drib = -15, def = +20, phy = +10)
            Position.CB -> Bias(pace = -5, shot = -20, pass = -10, drib = -10, def = +20, phy = +15)
            Position.LB, Position.RB -> Bias(pace = +10, shot = -10, pass = +5, drib = +5, def = +10, phy = +5)
            Position.CM -> Bias(pace = +5, shot = 0, pass = +15, drib = +10, def = +5, phy = +5)
            Position.CAM -> Bias(pace = +5, shot = +10, pass = +15, drib = +15, def = -10, phy = 0)
            Position.LW, Position.RW -> Bias(pace = +15, shot = +10, pass = +5, drib = +15, def = -15, phy = -5)
            Position.ST -> Bias(pace = +8, shot = +18, pass = -2, drib = +8, def = -20, phy = +10)
        }

        fun r(min: Int, max: Int) = rng.nextInt(min, max + 1)

        val pace = clampStat(ovr + r(-8, 8) + bias.pace)
        val shot = clampStat(ovr + r(-10, 10) + bias.shot)
        val pass = clampStat(ovr + r(-10, 10) + bias.pass)
        val drib = clampStat(ovr + r(-10, 10) + bias.drib)
        val def = clampStat(ovr + r(-10, 10) + bias.def)
        val phy = clampStat(ovr + r(-10, 10) + bias.phy)

        return PlayerStats(pace, shot, pass, drib, def, phy)
    }

    private data class Bias(
        val pace: Int,
        val shot: Int,
        val pass: Int,
        val drib: Int,
        val def: Int,
        val phy: Int
    )
}
