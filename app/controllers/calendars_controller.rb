class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    getWeek
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def getWeek
    # 曜日の配列を取得
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例) 今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    # Planテーブル内の本日から１週間のレコードを取得
    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      # 繰り返し処理をした結果を配列として保持
      plan = plans.map do |plan|
        # 本日から1週間以内の日付であれば、pushにて、変数planに代入されている配列の末尾にその日の予定の要素を追加
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end
      # 本日から1週間の日付と曜日、それぞれのプランを取得
      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, plans: today_plans, wday: wdays[(@todays_date).wday + x]}
      
      # トップページに表示したいある1週間のカレンダー情報を配列@week_daysに格納
      @week_days.push(days)
    end

  end
end
