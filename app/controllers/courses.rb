StudentDatabase.controllers :courses do
  
  before do
    protect_page
  end
  
  get :index do
    @courses = Course.all(params).all(order: [ :code.asc ])
    render 'courses/index'
  end
  
  get :show, :map => "/courses/:id" do
    @course = Course.get(params[:id])
    @records = @course.records(mp: @marking_period)
    render 'courses/show'
  end
  
end