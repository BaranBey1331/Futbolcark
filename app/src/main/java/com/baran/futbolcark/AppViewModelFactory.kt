package com.baran.futbolcark.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.baran.futbolcark.data.CareerRepository

class AppViewModelFactory(
    private val repo: CareerRepository
) : ViewModelProvider.Factory {
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        return AppViewModel(repo) as T
    }
}
