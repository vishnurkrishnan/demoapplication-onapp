xml = Builder::XmlMarkup.new(:indent => 0)
options = { 
 :caption => 'CPU Usage (Cores)',
 :xAxisName => 'Date / Time',
 :yAxisName => 'CPU Usage (Cores)',
 :yAxisMaxValue => '100',
 :numberSuffix => '%25',
 :decimalPrecision => '0',
 :showNames => '1',
 :showValues => '0',
 :rotateNames => '0',
 :showColumnShadow => '1',
 :animation => '1',
 :showAlternateHGridColor => '1',
 :AlternateHGridColor => 'ff5904',
 :divLineColor => 'ff5904',
 :divLineAlpha => '20',
 :alternateHGridAlpha => '5',
 :canvasBorderColor => '666666',
 :baseFontColor => '666666',
 :lineColor => 'FF5904',
 :lineAlpha => '85',
 :labelDisplay => 'rotate',
 :slantLabels => '1'
}
xml.chart(options) do
  @cpu_usage.last(24).each do |u|
    xml.set(:label => Time.parse(u['created_at']).in_time_zone.strftime("%d/%m %H:%M"), :value => u['cpu_time'])
  end
end



