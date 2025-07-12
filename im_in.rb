#!/usr/bin/env ruby

require 'json'
require 'date'
require 'io/console'

class TodoApp
    COLORS = {
        red: "\033[31m",
        green: "\033[32m",
        yellow: "\033[33m",
        blue: "\033[34m",
        magenta: "\033[35m",
        cyan: "\033[36m",
        white: "\033[37m",
        gray: "\033[90m",
        reset: "\033[0m",
        bold: "\033[1m",
        dim: "\033[2m"
    }

    PRIORITY_COLORS = {
        'high' => COLORS[:red],
        'medium' => COLORS[:yellow],
        'low' => COLORS[:green]
    }

    def initialize
        @tasks_file = "tasks.json"
        @tasks = load_tasks
        @current_filter = :all
    end

    def clear_screen
        system('clear') || system('cls')
    end

    def display_header
        puts COLORS[:cyan] + COLORS[:bold]
        puts "╔══════════════════════════════════════════════════════════════════════════════╗"
        puts "║                            📋 I'M IN! TODO MANAGER                           ║"
        puts "║                        Stay Organized, Stay Productive                       ║"
        puts "╚══════════════════════════════════════════════════════════════════════════════╝"
        puts COLORS[:reset]

        # Display quick stats
        total = @tasks.length
        completed = @tasks.count { |task| task[:completed] }
        pending = total - completed

        puts COLORS[:gray] + "📊 Tasks: #{total} total | #{completed} completed | #{pending} pending" + COLORS[:reset]
        puts COLORS[:gray] + "🎯 Filter: #{@current_filter.to_s.capitalize}" + COLORS[:reset]
        puts
    end

    def show_menu
        puts COLORS[:cyan] + "Choose your action:" + COLORS[:reset]
        puts COLORS[:gray] + "  1. ➕ Add task" + COLORS[:reset]
        puts COLORS[:gray] + "  2. 📋 Show tasks" + COLORS[:reset]
        puts COLORS[:gray] + "  3. ✅ Mark task as done" + COLORS[:reset]
        puts COLORS[:gray] + "  4. ❌ Delete task" + COLORS[:reset]
        puts COLORS[:gray] + "  5. ✏️  Edit task" + COLORS[:reset]
        puts COLORS[:gray] + "  6. 🎯 Set priority" + COLORS[:reset]
        puts COLORS[:gray] + "  7. 📅 Add due date" + COLORS[:reset]
        puts COLORS[:gray] + "  8. 🔍 Search tasks" + COLORS[:reset]
        puts COLORS[:gray] + "  9. 🏷️  Filter tasks" + COLORS[:reset]
        puts COLORS[:gray] + " 10. 📊 Show statistics" + COLORS[:reset]
        puts COLORS[:gray] + " 11. 🧹 Clear completed" + COLORS[:reset]
        puts COLORS[:gray] + " 12. 💾 Export tasks" + COLORS[:reset]
        puts COLORS[:gray] + " 13. 📥 Import tasks" + COLORS[:reset]
        puts COLORS[:gray] + " 14. ⚙️  Settings" + COLORS[:reset]
        puts COLORS[:gray] + " 15. 🚪 Exit" + COLORS[:reset]
        puts
        print COLORS[:white] + "Enter your choice (1-15): " + COLORS[:reset]
    end

    def load_tasks
        return [] unless File.exist?(@tasks_file)

        begin
            content = File.read(@tasks_file)
            return [] if content.strip.empty?

            parsed = JSON.parse(content, symbolize_names: true)

            # Handle old format (array of strings) or new format (array of hashes)
            if parsed.is_a?(Array) && parsed.first.is_a?(String)
                convert_old_format(parsed)
            else
                parsed.map { |task| symbolize_task(task) }
            end
        rescue JSON::ParserError, StandardError => e
            puts COLORS[:red] + "⚠️  Error loading tasks: #{e.message}" + COLORS[:reset]
            puts COLORS[:yellow] + "Starting with empty task list." + COLORS[:reset]
            sleep(2)
            []
        end
    end

    def symbolize_task(task)
        {
            id: task[:id] || generate_id,
            text: task[:text] || '',
            completed: task[:completed] || false,
            priority: task[:priority] || 'medium',
            due_date: task[:due_date],
            created_at: task[:created_at] || Time.now.strftime("%Y-%m-%d %H:%M"),
            tags: task[:tags] || []
        }
    end

    def convert_old_format(old_tasks)
        old_tasks.map.with_index do |task_str, index|
            {
                id: generate_id,
                text: task_str.gsub(/^\[.\] /, ''),
                completed: task_str.start_with?('[✓]'),
                priority: 'medium',
                due_date: nil,
                created_at: Time.now.strftime("%Y-%m-%d %H:%M"),
                tags: []
            }
        end
    end

    def generate_id
        Time.now.to_i.to_s(36) + rand(1000).to_s(36)
    end

    def save_tasks
        begin
            File.open(@tasks_file, "w") do |file|
                file.puts JSON.pretty_generate(@tasks)
            end
        rescue StandardError => e
            puts COLORS[:red] + "⚠️  Error saving tasks: #{e.message}" + COLORS[:reset]
            sleep(2)
        end
    end

    def add_task
        print COLORS[:cyan] + "Enter the new task: " + COLORS[:reset]
        text = gets.chomp.strip

        return if text.empty?

        # Extract tags from text (words starting with #)
        tags = text.scan(/#\w+/).map { |tag| tag[1..-1] }

        task = {
            id: generate_id,
            text: text,
            completed: false,
            priority: 'medium',
            due_date: nil,
            created_at: Time.now.strftime("%Y-%m-%d %H:%M"),
            tags: tags
        }

        @tasks << task
        save_tasks

        puts COLORS[:green] + "✅ Task added successfully!" + COLORS[:reset]

        # Ask for priority
        print COLORS[:yellow] + "Set priority? (h/m/l or Enter for medium): " + COLORS[:reset]
        priority_input = gets.chomp.downcase

        case priority_input
        when 'h', 'high'
            task[:priority] = 'high'
        when 'l', 'low'
            task[:priority] = 'low'
        when 'm', 'medium', ''
            task[:priority] = 'medium'
        end

        save_tasks
        sleep(1)
    end

    def show_tasks
        filtered_tasks = filter_tasks

        if filtered_tasks.empty?
            puts COLORS[:yellow] + "📭 No tasks found matching current filter." + COLORS[:reset]
            return
        end

        puts COLORS[:cyan] + "\n📋 Your Tasks:" + COLORS[:reset]
        puts "─" * 80

        filtered_tasks.each_with_index do |task, display_index|
            status = task[:completed] ? COLORS[:green] + "[✓]" : COLORS[:red] + "[ ]"
            priority_color = PRIORITY_COLORS[task[:priority]]
            priority_symbol = case task[:priority]
        when 'high' then '🔴'
        when 'medium' then '🟡'
        when 'low' then '🟢'
        end

        real_index = @tasks.index(task) + 1

        puts "#{status} #{real_index.to_s.rjust(2)}. #{priority_symbol} #{priority_color}#{task[:text]}#{COLORS[:reset]}"

        # Show additional info
        info_parts = []
        info_parts << "📅 #{task[:due_date]}" if task[:due_date]
        info_parts << "🏷️  #{task[:tags].map { |tag| '#' + tag }.join(' ')}" unless task[:tags].empty?
        info_parts << "📝 #{task[:created_at]}"

        unless info_parts.empty?
            puts COLORS[:gray] + "    " + info_parts.join(" | ") + COLORS[:reset]
        end

        # Check if overdue
        if task[:due_date] && !task[:completed]
            due_date = Date.parse(task[:due_date]) rescue nil
            if due_date && due_date < Date.today
                puts COLORS[:red] + "    ⚠️  OVERDUE!" + COLORS[:reset]
            end
        end
    end

    puts "─" * 80
end

def filter_tasks
    case @current_filter
    when :completed
        @tasks.select { |task| task[:completed] }
    when :pending
        @tasks.select { |task| !task[:completed] }
    when :high_priority
        @tasks.select { |task| task[:priority] == 'high' }
    when :overdue
        @tasks.select do |task|
            next false if task[:completed] || !task[:due_date]
            due_date = Date.parse(task[:due_date]) rescue nil
            due_date && due_date < Date.today
        end
    else
        @tasks
    end
end

def mark_task_done
    return if @tasks.empty?

    show_tasks
    puts
    print COLORS[:cyan] + "Enter task number to mark as done: " + COLORS[:reset]

    begin
        index = gets.to_i - 1

        if index >= 0 && index < @tasks.length
            if @tasks[index][:completed]
                puts COLORS[:yellow] + "⚠️  Task is already completed!" + COLORS[:reset]
            else
                @tasks[index][:completed] = true
                save_tasks
                puts COLORS[:green] + "✅ Task marked as completed!" + COLORS[:reset]
            end
        else
            puts COLORS[:red] + "❌ Invalid task number." + COLORS[:reset]
        end
    rescue ArgumentError
        puts COLORS[:red] + "❌ Please enter a valid number." + COLORS[:reset]
    end

    sleep(1)
end

def delete_task
    return if @tasks.empty?

    show_tasks
    puts
    print COLORS[:cyan] + "Enter task number to delete: " + COLORS[:reset]

    begin
        index = gets.to_i - 1

        if index >= 0 && index < @tasks.length
            task_text = @tasks[index][:text]
            print COLORS[:red] + "⚠️  Are you sure you want to delete '#{task_text}'? (y/N): " + COLORS[:reset]

            if gets.chomp.downcase == 'y'
                @tasks.delete_at(index)
                save_tasks
                puts COLORS[:green] + "✅ Task deleted successfully!" + COLORS[:reset]
            else
                puts COLORS[:yellow] + "📝 Task deletion cancelled." + COLORS[:reset]
            end
        else
            puts COLORS[:red] + "❌ Invalid task number." + COLORS[:reset]
        end
    rescue ArgumentError
        puts COLORS[:red] + "❌ Please enter a valid number." + COLORS[:reset]
    end

    sleep(1)
end

def edit_task
    return if @tasks.empty?

    show_tasks
    puts
    print COLORS[:cyan] + "Enter task number to edit: " + COLORS[:reset]

    begin
        index = gets.to_i - 1

        if index >= 0 && index < @tasks.length
            task = @tasks[index]
            puts COLORS[:yellow] + "Current text: #{task[:text]}" + COLORS[:reset]
            print COLORS[:cyan] + "Enter new text (or press Enter to keep current): " + COLORS[:reset]

            new_text = gets.chomp.strip
            unless new_text.empty?
                # Extract new tags
                new_tags = new_text.scan(/#\w+/).map { |tag| tag[1..-1] }

                task[:text] = new_text
                task[:tags] = new_tags
                save_tasks
                puts COLORS[:green] + "✅ Task updated successfully!" + COLORS[:reset]
            else
                puts COLORS[:yellow] + "📝 Task text unchanged." + COLORS[:reset]
            end
        else
            puts COLORS[:red] + "❌ Invalid task number." + COLORS[:reset]
        end
    rescue ArgumentError
        puts COLORS[:red] + "❌ Please enter a valid number." + COLORS[:reset]
    end

    sleep(1)
end

def set_priority
    return if @tasks.empty?

    show_tasks
    puts
    print COLORS[:cyan] + "Enter task number to set priority: " + COLORS[:reset]

    begin
        index = gets.to_i - 1

        if index >= 0 && index < @tasks.length
            task = @tasks[index]
            puts COLORS[:yellow] + "Current priority: #{task[:priority]}" + COLORS[:reset]
            print COLORS[:cyan] + "Enter new priority (high/medium/low): " + COLORS[:reset]

            new_priority = gets.chomp.downcase

            if %w[high medium low].include?(new_priority)
                task[:priority] = new_priority
                save_tasks
                puts COLORS[:green] + "✅ Priority updated successfully!" + COLORS[:reset]
            else
                puts COLORS[:red] + "❌ Invalid priority. Use: high, medium, or low." + COLORS[:reset]
            end
        else
            puts COLORS[:red] + "❌ Invalid task number." + COLORS[:reset]
        end
    rescue ArgumentError
        puts COLORS[:red] + "❌ Please enter a valid number." + COLORS[:reset]
    end

    sleep(1)
end

def add_due_date
    return if @tasks.empty?

    show_tasks
    puts
    print COLORS[:cyan] + "Enter task number to add due date: " + COLORS[:reset]

    begin
        index = gets.to_i - 1

        if index >= 0 && index < @tasks.length
            task = @tasks[index]
            puts COLORS[:yellow] + "Current due date: #{task[:due_date] || 'None'}" + COLORS[:reset]
            print COLORS[:cyan] + "Enter due date (YYYY-MM-DD) or 'none' to remove: " + COLORS[:reset]

            date_input = gets.chomp.strip

            if date_input.downcase == 'none'
                task[:due_date] = nil
                save_tasks
                puts COLORS[:green] + "✅ Due date removed!" + COLORS[:reset]
            else
                begin
                    Date.parse(date_input)
                    task[:due_date] = date_input
                    save_tasks
                    puts COLORS[:green] + "✅ Due date set successfully!" + COLORS[:reset]
                rescue Date::Error
                    puts COLORS[:red] + "❌ Invalid date format. Use YYYY-MM-DD." + COLORS[:reset]
                end
            end
        else
            puts COLORS[:red] + "❌ Invalid task number." + COLORS[:reset]
        end
    rescue ArgumentError
        puts COLORS[:red] + "❌ Please enter a valid number." + COLORS[:reset]
    end

    sleep(1)
end

def search_tasks
    print COLORS[:cyan] + "Enter search term: " + COLORS[:reset]
    search_term = gets.chomp.strip.downcase

    return if search_term.empty?

    matching_tasks = @tasks.select do |task|
        task[:text].downcase.include?(search_term) ||
                task[:tags].any? { |tag| tag.downcase.include?(search_term) }
    end

    if matching_tasks.empty?
        puts COLORS[:yellow] + "📭 No tasks found matching '#{search_term}'." + COLORS[:reset]
    else
        puts COLORS[:cyan] + "\n🔍 Search Results for '#{search_term}':" + COLORS[:reset]
        puts "─" * 50

        matching_tasks.each do |task|
            status = task[:completed] ? COLORS[:green] + "[✓]" : COLORS[:red] + "[ ]"
            priority_color = PRIORITY_COLORS[task[:priority]]

            puts "#{status} #{priority_color}#{task[:text]}#{COLORS[:reset]}"
        end

        puts "─" * 50
        puts COLORS[:gray] + "Found #{matching_tasks.length} matching task(s)." + COLORS[:reset]
    end

    puts "\nPress Enter to continue..."
    gets
end

def filter_menu
    puts COLORS[:cyan] + "\n🏷️  Filter Options:" + COLORS[:reset]
    puts "1. All tasks"
    puts "2. Completed tasks"
    puts "3. Pending tasks"
    puts "4. High priority tasks"
    puts "5. Overdue tasks"
    puts
    print COLORS[:cyan] + "Choose filter (1-5): " + COLORS[:reset]

    choice = gets.chomp

    case choice
    when '1'
        @current_filter = :all
    when '2'
        @current_filter = :completed
    when '3'
        @current_filter = :pending
    when '4'
        @current_filter = :high_priority
    when '5'
        @current_filter = :overdue
    else
        puts COLORS[:red] + "❌ Invalid choice." + COLORS[:reset]
        sleep(1)
        return
    end

    puts COLORS[:green] + "✅ Filter applied: #{@current_filter.to_s.capitalize}" + COLORS[:reset]
    sleep(1)
end

def show_statistics
    total = @tasks.length
    completed = @tasks.count { |task| task[:completed] }
    pending = total - completed
    high_priority = @tasks.count { |task| task[:priority] == 'high' }
    overdue = @tasks.count do |task|
        next false if task[:completed] || !task[:due_date]
        due_date = Date.parse(task[:due_date]) rescue nil
        due_date && due_date < Date.today
    end

    puts COLORS[:cyan] + "\n📊 Task Statistics:" + COLORS[:reset]
    puts "─" * 40
    puts COLORS[:white] + "📋 Total Tasks: #{total}" + COLORS[:reset]
    puts COLORS[:green] + "✅ Completed: #{completed}" + COLORS[:reset]
    puts COLORS[:yellow] + "⏳ Pending: #{pending}" + COLORS[:reset]
    puts COLORS[:red] + "🔴 High Priority: #{high_priority}" + COLORS[:reset]
    puts COLORS[:red] + "⚠️  Overdue: #{overdue}" + COLORS[:reset]

    if total > 0
        completion_rate = (completed.to_f / total * 100).round(1)
        puts COLORS[:cyan] + "📈 Completion Rate: #{completion_rate}%" + COLORS[:reset]
    end

    puts "─" * 40

    puts "\nPress Enter to continue..."
    gets
end

def clear_completed
    completed_tasks = @tasks.select { |task| task[:completed] }

    if completed_tasks.empty?
        puts COLORS[:yellow] + "📭 No completed tasks to clear." + COLORS[:reset]
        sleep(1)
        return
    end

    puts COLORS[:yellow] + "Found #{completed_tasks.length} completed task(s)." + COLORS[:reset]
    print COLORS[:red] + "⚠️  Are you sure you want to delete all completed tasks? (y/N): " + COLORS[:reset]

    if gets.chomp.downcase == 'y'
        @tasks.reject! { |task| task[:completed] }
        save_tasks
        puts COLORS[:green] + "✅ #{completed_tasks.length} completed task(s) cleared!" + COLORS[:reset]
    else
        puts COLORS[:yellow] + "📝 Operation cancelled." + COLORS[:reset]
    end

    sleep(1)
end

def export_tasks
    filename = "tasks_export_#{Date.today.strftime('%Y%m%d')}.json"

    begin
        File.open(filename, 'w') do |file|
            file.puts JSON.pretty_generate(@tasks)
        end
        puts COLORS[:green] + "✅ Tasks exported to #{filename}" + COLORS[:reset]
    rescue StandardError => e
        puts COLORS[:red] + "❌ Error exporting tasks: #{e.message}" + COLORS[:reset]
    end

    sleep(2)
end

def import_tasks
    print COLORS[:cyan] + "Enter filename to import from: " + COLORS[:reset]
    filename = gets.chomp.strip

    unless File.exist?(filename)
        puts COLORS[:red] + "❌ File not found: #{filename}" + COLORS[:reset]
        sleep(1)
        return
    end

    begin
        content = File.read(filename)
        imported_tasks = JSON.parse(content, symbolize_names: true)

        imported_tasks.each { |task| task[:id] = generate_id }

        @tasks.concat(imported_tasks.map { |task| symbolize_task(task) })
        save_tasks

        puts COLORS[:green] + "✅ Imported #{imported_tasks.length} task(s) from #{filename}" + COLORS[:reset]
    rescue StandardError => e
        puts COLORS[:red] + "❌ Error importing tasks: #{e.message}" + COLORS[:reset]
    end

    sleep(2)
end

def settings_menu
    puts COLORS[:cyan] + "\n⚙️  Settings:" + COLORS[:reset]
    puts "1. Reset all tasks"
    puts "2. Change tasks file location"
    puts "3. Back to main menu"
    puts
    print COLORS[:cyan] + "Choose option (1-3): " + COLORS[:reset]

    choice = gets.chomp

    case choice
    when '1'
        print COLORS[:red] + "⚠️  Are you sure you want to delete ALL tasks? (type 'DELETE' to confirm): " + COLORS[:reset]
        if gets.chomp == 'DELETE'
            @tasks.clear
            save_tasks
            puts COLORS[:green] + "✅ All tasks have been deleted." + COLORS[:reset]
        else
            puts COLORS[:yellow] + "📝 Operation cancelled." + COLORS[:reset]
        end
    when '2'
        print COLORS[:cyan] + "Enter new tasks file path: " + COLORS[:reset]
        new_file = gets.chomp.strip
        if !new_file.empty?
            @tasks_file = new_file
            @tasks = load_tasks
            puts COLORS[:green] + "✅ Tasks file location changed to: #{@tasks_file}" + COLORS[:reset]
        end
    when '3'
        return
    else
        puts COLORS[:red] + "❌ Invalid choice." + COLORS[:reset]
    end

    sleep(2)
end

def run
    loop do
        clear_screen
        display_header
        show_menu

        choice = gets.chomp

        case choice
        when '1'
            add_task
        when '2'
            show_tasks
            unless @tasks.empty?
                puts "\nPress Enter to continue..."
                gets
            end
        when '3'
            mark_task_done
        when '4'
            delete_task
        when '5'
            edit_task
        when '6'
            set_priority
        when '7'
            add_due_date
        when '8'
            search_tasks
        when '9'
            filter_menu
        when '10'
            show_statistics
        when '11'
            clear_completed
        when '12'
            export_tasks
        when '13'
            import_tasks
        when '14'
            settings_menu
        when '15'
            puts COLORS[:green] + "\n👋 Thanks for using I'm In! Stay productive! ✨" + COLORS[:reset]
            break
        else
            puts COLORS[:red] + "❌ Invalid option. Please choose 1-15." + COLORS[:reset]
            sleep(1)
        end
    end
end
end

# Main execution
if __FILE__ == $0
    begin
        app = TodoApp.new
        app.run
    rescue Interrupt
        puts "\n\n" + TodoApp::COLORS[:yellow] + "👋 Goodbye! Your tasks are safely saved." + TodoApp::COLORS[:reset]
    rescue StandardError => e
        puts TodoApp::COLORS[:red] + "❌ An error occurred: #{e.message}" + TodoApp::COLORS[:reset]
        puts "Please report this issue if it persists."
    end
end
