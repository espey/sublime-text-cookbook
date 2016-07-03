require 'spec_helper'

describe 'Tests that the correct install recipe is included' do
  let(:chef_run) do
    chef_runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04')
    chef_runner.converge(described_recipe)
  end

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end

  it 'includes the sublime-text::platform_ubuntu recipe' do
    expect(chef_run).to include_recipe('sublime-text::platform_ubuntu')
  end
end
