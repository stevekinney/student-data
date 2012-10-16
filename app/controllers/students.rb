StudentDatabase.controllers :students do

  get :index do
    @students = Student.active.all(params).all(order: [ :homeroom.asc ])
    render 'students/index'
  end
  
  get :ineligible do
    @title = "Ineligible List"
    @students = Student.active.ineligible.all(order: [ :homeroom.asc ]).all(params)
    render 'students/index'
  end
  
  get :probation, :map => "/students/probation/:level" do
    @title = "Probation: Level #{params[:level]}"
    case params[:level]
    when "1"
      @students = Student.on_level_1_probation
    when "2"
      @students = Student.on_level_2_probation
    when "3"
      @students = Student.failing
    end
    render 'students/index'
  end
  
  get :show, :map => "/students/:id" do
    @student = Student.get(params[:id])
    @records = @student.records(mp: @marking_period)
    render 'students/show'
  end
  
end