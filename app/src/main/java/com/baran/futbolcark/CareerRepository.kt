package com.baran.futbolcark.data

import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.edit
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map

class CareerRepository(
    private val store: DataStore<Preferences>
) {
    val careerJson: Flow<String?> = store.data.map { it[Keys.CAREER_JSON] }

    suspend fun saveCareerJson(json: String) {
        store.edit { it[Keys.CAREER_JSON] = json }
    }

    suspend fun clear() {
        store.edit { it.remove(Keys.CAREER_JSON) }
    }
}
