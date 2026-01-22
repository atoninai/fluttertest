package com.ssc26.ssc26

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import java.time.LocalDate
import java.time.temporal.ChronoUnit

class SSCCountdownWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    companion object {
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val views = RemoteViews(context.packageName, R.layout.ssc_countdown_widget)
            
            // Calculate days remaining until SSC exam (Feb 14, 2026)
            val today = LocalDate.now()
            val examDate = LocalDate.of(2026, 2, 14)
            val daysRemaining = ChronoUnit.DAYS.between(today, examDate)
            
            views.setTextViewText(R.id.widget_days_count, daysRemaining.toString())
            views.setTextViewText(R.id.widget_days_label, 
                if (daysRemaining == 1L) "Day Until SSC" else "Days Until SSC")
            
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
