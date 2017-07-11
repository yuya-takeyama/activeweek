RSpec.describe ActiveWeek::Week do
  describe '#year' do
    it 'returns the year of the week' do
      expect(described_class.new(2017, 1).year).to eq 2017
    end

    context 'when the number of the week is negative' do
      it 'returns calculated year' do
        expect(described_class.new(2017, -1).year).to eq 2017
      end
    end
  end

  describe '#number' do
    it 'returns the number of the week' do
      expect(described_class.new(2017, 1).number).to eq 1
    end

    context 'when the number of the week is negative' do
      it 'returns calculated number' do
        expect(described_class.new(2017, -1).number).to eq 52
      end
    end
  end

  describe '#first_day' do
    subject { described_class.new(2017, 1).first_day }

    it 'returns Date of the first day of the week' do
      expect(subject).to eq Date.new(2017, 1, 2)
    end
  end

  describe '#last_day' do
    subject { described_class.new(2017, 1).last_day }

    it 'returns Date of the first day of the week' do
      expect(subject).to eq Date.new(2017, 1, 8)
    end
  end

  describe '#next_week' do
    subject { described_class.new(year, number).next_week }

    context "when the it's the first week of the year" do
      let(:year)   { 2017 }
      let(:number) { 1 }

      it 'returns the second week of the year' do
        expect(subject).to eq described_class.new(2017, 2)
      end
    end

    context "when the it's the last week of the year" do
      let(:year)   { 2017 }
      let(:number) { 52 }

      it 'returns the first week of the next year' do
        expect(subject).to eq described_class.new(2018, 1)
      end
    end
  end

  describe '#prev_week' do
    subject { described_class.new(year, number).prev_week }

    context "when the it's the second week of the year" do
      let(:year)   { 2017 }
      let(:number) { 2 }

      it 'returns the first week of the year' do
        expect(subject).to eq described_class.new(2017, 1)
      end
    end

    context "when the it's the first week of the year" do
      let(:year)   { 2017 }
      let(:number) { 1 }

      it 'returns the last week of the previous year' do
        expect(subject).to eq described_class.new(2016, 52)
      end
    end
  end

  describe '<=>' do
    it 'is comparable' do
      expect(described_class.new(2017, 1)).to eq described_class.new(2017, 1)
      expect(described_class.new(2017, 1)).to be >= described_class.new(2017, 1)
      expect(described_class.new(2017, 1)).to be <= described_class.new(2017, 1)
      expect(described_class.new(2017, 1)).not_to be > described_class.new(2017, 1)
      expect(described_class.new(2017, 1)).not_to be < described_class.new(2017, 1)

      expect(described_class.new(2017, 1)).not_to eq described_class.new(2017, 2)
      expect(described_class.new(2017, 1)).not_to be >= described_class.new(2017, 2)
      expect(described_class.new(2017, 1)).to be <= described_class.new(2017, 2)
      expect(described_class.new(2017, 1)).not_to be > described_class.new(2017, 2)
      expect(described_class.new(2017, 1)).to be < described_class.new(2017, 2)

      expect(described_class.new(2017, -1)).to eq described_class.new(2017, 52)
      expect(described_class.new(2017, 1)).to eq described_class.new(2017, -52)
    end

    it 'raises ArgumentError if the comparison is unexpected object' do
      # see: https://bugs.ruby-lang.org/issues/7688
      skip if RUBY_VERSION.start_with?('2.2.')

      expect {
        described_class.new(2017, 1) == Time.now
      }.to raise_error ArgumentError
    end
  end

  describe '#each_day' do
    let(:week) { described_class.new(2017, 1) }

    context 'with block' do
      it 'yields dates in the week' do
        expect { |b| week.each_day(&b) }.to yield_successive_args(
          Date.new(2017, 1, 2),
          Date.new(2017, 1, 3),
          Date.new(2017, 1, 4),
          Date.new(2017, 1, 5),
          Date.new(2017, 1, 6),
          Date.new(2017, 1, 7),
          Date.new(2017, 1, 8),
        )
      end

      it 'returns itself' do
        ret = week.each_day { }
        expect(ret).to be week
      end
    end

    context 'without block' do
      it 'returns Date objects as a Enumerator' do
        dates = week.each_day
        expect(dates).to be_an_instance_of Enumerator
        expect(dates).to match_array([
          Date.new(2017, 1, 2),
          Date.new(2017, 1, 3),
          Date.new(2017, 1, 4),
          Date.new(2017, 1, 5),
          Date.new(2017, 1, 6),
          Date.new(2017, 1, 7),
          Date.new(2017, 1, 8),
        ])
      end
    end
  end

  describe '.current' do
    shared_examples 'returns Week' do
      subject do
        travel_to(Time.utc(year, month, day)) do
          described_class.current
        end
      end

      context "when it's on Jun. 1, 2017" do
        let(:year)  { 2017 }
        let(:month) { 1 }
        let(:day)   { 1 }

        it 'returns 52th week of 2016' do
          expect(subject).to eq described_class.new(2016, 52)
        end
      end

      context "when it's on Jun. 2, 2017" do
        let(:year)  { 2017 }
        let(:month) { 1 }
        let(:day)   { 2 }

        it 'returns first week of 2017' do
          expect(subject).to eq described_class.new(2017, 1)
        end
      end

      context "when it's on Jun. 8, 2017" do
        let(:year)  { 2017 }
        let(:month) { 1 }
        let(:day)   { 8 }

        it 'returns first week of 2017' do
          expect(subject).to eq described_class.new(2017, 1)
        end
      end

      context "when it's on Jun. 9, 2017" do
        let(:year)  { 2017 }
        let(:month) { 1 }
        let(:day)   { 9 }

        it 'returns second week of 2017' do
          expect(subject).to eq described_class.new(2017, 2)
        end
      end
    end

    context 'without Time.zone' do
      subject do
        with_timezone(nil) do
          travel_to(Time.utc(year, month, day)) do
            described_class.current
          end
        end
      end

      it_behaves_like 'returns Week'
    end

    context 'with Time.zone = "UTC"' do
      subject do
        with_timezone('UTC') do
          travel_to(Time.zone.local(year, month, day)) do
            described_class.current
          end
        end
      end

      it_behaves_like 'returns Week'
    end

    context 'with Time.zone = "Asia/Tokyo"' do
      subject do
        with_timezone('Asia/Tokyo') do
          travel_to(Time.zone.local(year, month, day)) do
            described_class.current
          end
        end
      end

      it_behaves_like 'returns Week'
    end

    def with_timezone(timezone)
      orig_timezone = Time.zone
      Time.zone = timezone
      yield
    ensure
      Time.zone = orig_timezone
    end
  end

  describe 'Using as keys of Hash' do
    it 'can be used as keys of Hash' do
      h = {}

      h[ActiveWeek::Week.new(2017, 1)] = 1

      h[ActiveWeek::Week.new(2020, 6)] = 1
      h[ActiveWeek::Week.new(2020, 6)] += 1
      h[ActiveWeek::Week.new(2020, 6)] += 1

      expect(h[ActiveWeek::Week.new(2017, 1)]).to eq 1
      expect(h[ActiveWeek::Week.new(2020, 6)]).to eq 3
    end
  end

  describe 'Using for building Range' do
    it 'can be used for building Range' do
      inclusive_range = (ActiveWeek::Week.new(2017, 1)..ActiveWeek::Week.new(2017, 10))
      exclusive_range = (ActiveWeek::Week.new(2017, 1)...ActiveWeek::Week.new(2017, 10))
      range_across_years = (ActiveWeek::Week.new(2017, 1)..ActiveWeek::Week.new(2020, 1))

      expect(inclusive_range.to_a.size).to eq 10
      expect(inclusive_range.to_a.first).to eq ActiveWeek::Week.new(2017, 1)
      expect(inclusive_range.to_a.last).to eq ActiveWeek::Week.new(2017, 10)

      expect(exclusive_range.to_a.size).to eq 9
      expect(exclusive_range.to_a.first).to eq ActiveWeek::Week.new(2017, 1)
      expect(exclusive_range.to_a.last).to eq ActiveWeek::Week.new(2017, 9)

      expect(range_across_years.to_a.size).to eq 157
      expect(range_across_years.to_a.first).to eq ActiveWeek::Week.new(2017, 1)
      expect(range_across_years.to_a.last).to eq ActiveWeek::Week.new(2020, 1)
    end
  end
end
