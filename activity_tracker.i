-- Copyright 2014-2025 The Ideal Authors. All rights reserved.
--
-- Use of this source code is governed by a BSD-style
-- license that can be found in the LICENSE file or at
-- https://theideal.org/license/

--- Activity Tracker Application
---
--- A simple activity tracking system that allows users to:
--- - Record activities with name, duration, and category
--- - View all recorded activities
--- - Calculate total time spent on activities
--- - Group activities by category
--- - Display statistics and summaries

--- Category enum for different types of activities
enum activity_category {
  work;
  exercise;
  learning;
  leisure;
  social;
  personal;

  --- Convert category to string representation
  string to_string() {
    switch (this) {
      case work:
        return "Work";
      case exercise:
        return "Exercise";
      case learning:
        return "Learning";
      case leisure:
        return "Leisure";
      case social:
        return "Social";
      case personal:
        return "Personal";
      default:
        return "Unknown";
    }
  }
}

--- Activity datatype representing a single tracked activity
--- Activities are immutable once created
auto_constructor datatype activity {
  implements stringable;

  string name;
  nonnegative duration_minutes;
  activity_category category;

  override string to_string() pure {
    return name ++ " (" ++ duration_minutes ++ " min) - " ++ category.to_string();
  }
}

--- ActivityTracker class manages a collection of activities
class activity_tracker {
  var list[activity] activities;

  --- Constructor initializes an empty activity list
  activity_tracker() {
    activities = [];
  }

  --- Add a new activity to the tracker
  void add_activity(string name, nonnegative duration_minutes, activity_category category) {
    new_activity : activity.new(name, duration_minutes, category);
    activities.append(new_activity);
    println("Added activity: " ++ new_activity.to_string());
  }

  --- Display all tracked activities
  void show_all_activities() {
    println();
    println("=== All Activities ===");

    if (activities.size == 0) {
      println("No activities tracked yet.");
      return;
    }

    for (act : activities) {
      println("  " ++ act.to_string());
    }
  }

  --- Calculate and return total time spent on all activities
  nonnegative get_total_time() {
    var nonnegative total : 0;
    for (act : activities) {
      total += act.duration_minutes;
    }
    return total;
  }

  --- Display total time statistics
  void show_total_time() {
    total : get_total_time();
    println();
    println("=== Total Time ===");
    println("Total minutes: " ++ total);
    println("Total hours: " ++ (total / 60) ++ "h " ++ (total % 60) ++ "m");
  }

  --- Calculate time spent on a specific category
  nonnegative get_time_by_category(activity_category category) {
    var nonnegative total : 0;
    for (act : activities) {
      if (act.category == category) {
        total += act.duration_minutes;
      }
    }
    return total;
  }

  --- Display statistics grouped by category
  void show_category_statistics() {
    println();
    println("=== Category Statistics ===");

    total_time : get_total_time();
    if (total_time == 0) {
      println("No activities to analyze.");
      return;
    }

    -- Check each category
    categories : [
      activity_category.work,
      activity_category.exercise,
      activity_category.learning,
      activity_category.leisure,
      activity_category.social,
      activity_category.personal
    ];

    for (cat : categories) {
      time : get_time_by_category(cat);
      if (time > 0) {
        percentage : (time * 100) / total_time;
        println("  " ++ cat.to_string() ++ ": " ++ time ++ " min (" ++ percentage ++ "%)");
      }
    }
  }

  --- Display a summary report
  void show_summary() {
    println();
    println("==================================");
    println("    ACTIVITY TRACKER SUMMARY");
    println("==================================");
    println("Total activities: " ++ activities.size);
    show_total_time();
    show_category_statistics();
    show_all_activities();
    println();
    println("==================================");
  }
}

--- Main function demonstrating the activity tracker
void main() {
  println("Starting Activity Tracker...");
  println();

  -- Create a new tracker
  tracker : activity_tracker.new();

  -- Add sample activities
  println("Adding activities...");
  tracker.add_activity("Morning workout", 45, activity_category.exercise);
  tracker.add_activity("Project meeting", 60, activity_category.work);
  tracker.add_activity("Code review", 30, activity_category.work);
  tracker.add_activity("Read programming book", 90, activity_category.learning);
  tracker.add_activity("Watch movie", 120, activity_category.leisure);
  tracker.add_activity("Coffee with friends", 75, activity_category.social);
  tracker.add_activity("Meditation", 20, activity_category.personal);
  tracker.add_activity("Algorithm practice", 60, activity_category.learning);
  tracker.add_activity("Evening run", 30, activity_category.exercise);
  tracker.add_activity("Team collaboration", 90, activity_category.work);

  -- Display comprehensive summary
  tracker.show_summary();

  -- Demonstrate adding more activities
  println();
  println("Adding more activities...");
  tracker.add_activity("Yoga session", 40, activity_category.exercise);
  tracker.add_activity("Write documentation", 45, activity_category.work);

  -- Show updated statistics
  println();
  println("Updated statistics:");
  tracker.show_total_time();
  tracker.show_category_statistics();
}

-- Execute the main function
main();
