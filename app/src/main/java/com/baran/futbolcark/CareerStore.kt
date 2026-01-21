package com.baran.futbolcark.data

import android.content.Context
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore

val Context.careerStore by preferencesDataStore(name = "career_store")

internal object Keys {
    val CAREER_JSON = stringPreferencesKey("career_json")
}
