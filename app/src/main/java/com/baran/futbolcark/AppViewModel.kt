package com.baran.futbolcark.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.baran.futbolcark.data.CareerRepository
import com.baran.futbolcark.game.WheelEngine
import com.baran.futbolcark.models.*
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

class AppViewModel(
    private val repo: CareerRepository
) : ViewModel() {

    private val json = Json { ignoreUnknownKeys = true; prettyPrint = false }

    private val _career = MutableStateFlow<CareerState?>(null)
    val career: StateFlow<CareerState?> = _career.asStateFlow()

    private val _draft = MutableStateFlow(DraftPlayer())
    val draft: StateFlow<DraftPlayer> = _draft.asStateFlow()

    init {
        viewModelScope.launch {
            repo.careerJson.collect { raw ->
                _career.value = raw?.let {
                    runCatching { json.decodeFromString(CareerState.serializer(), it) }.getOrNull()
                }
            }
        }
    }

    fun newDraft() {
        _draft.value = DraftPlayer()
    }

    fun updateDraft(
        firstName: String = _draft.value.firstName,
        lastName: String = _draft.value.lastName,
        continent: String = _draft.value.continent,
        country: String = _draft.value.country,
        position: Position = _draft.value.position,
        jerseyNumber: Int = _draft.value.jerseyNumber
    ) {
        _draft.value = _draft.value.copy(
            firstName = firstName,
            lastName = lastName,
            continent = continent,
            country = country,
            position = position,
            jerseyNumber = jerseyNumber
        )
    }

    fun setDraftRating(rating: Int) {
        _draft.value = _draft.value.copy(rating = rating)
    }

    fun setDraftClub(club: String) {
        _draft.value = _draft.value.copy(club = club)
    }

    fun setDraftContractYears(years: Int) {
        _draft.value = _draft.value.copy(contractYears = years)
    }

    fun finalizeCareerIfReady() {
        val d = _draft.value
        val rating = d.rating ?: return
        val club = d.club ?: return
        val years = d.contractYears ?: return

        val stats = WheelEngine.makeStats(rating, d.position)

        val player = PlayerProfile(
            firstName = d.firstName,
            lastName = d.lastName,
            continent = d.continent,
            country = d.country,
            position = d.position,
            jerseyNumber = d.jerseyNumber,
            rating = rating,
            club = club,
            contractYears = years,
            stats = stats
        )
        val state = CareerState(player)
        viewModelScope.launch {
            repo.saveCareerJson(json.encodeToString(state))
        }
    }

    fun clearCareer() {
        viewModelScope.launch { repo.clear() }
    }
}
