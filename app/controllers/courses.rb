StudentDatabase.controllers :courses do
  
  before { protect_page }

  get :index, provides: [:html, :json] do
    @courses = Course.all(order: [ :code.asc ], year: @year).all(params)
    case content_type
      when :html then render 'courses/index'
      when :json then return @courses.to_json
    end
  end
  
  get :teachers, with: :teacher, provides: [:html, :json] do
    @title = "Courses Offered by #{params[:teacher].capitalize}"
    @courses = Course.all(order: [ :code.asc ], year: @year, teacher: params[:teacher])
    case content_type
      when :html then render 'courses/index'
      when :json then return @courses.to_json
    end
  end
  
  get :teachers, provides: :json do
    if params[:teacher]
      redirect url_for :courses, :teachers, teacher: params[:teacher]
    else
      return Course.teachers.to_json
    end
  end

  get :show, with: :id, provides: [:html, :json] do
    @course = Course.get(params[:id])
    @records = @course.records(mp: @marking_period, year: @year)
    case content_type
      when :html then render 'courses/show'
      when :json then return {course: @course, students: @course.students}.to_json
    end
  end

  get :show_all_sections, map: '/courses/code/:id', provides: [:html, :json] do
    @courses = Course.all(course_id: params[:id])
    @course = @courses.first
    @records = @courses.records(mp: @marking_period, year: @year)
    case content_type
      when :html then render 'courses/show'
      when :json then return {courses: @courses, students: @courses.students}.to_json
    end
  end

  get :show_for_mp, map: "/courses/show/:id/mp/:mp", provides: [:html, :json] do
    @course = Course.get(params[:id])
    @marking_period = params[:mp]
    @records = @course.records(mp: @marking_period, year: @year)
    case content_type
      when :html then render 'courses/show'
      when :json then return {course: @course, students: @course.students}.to_json
    end
  end
  
end
