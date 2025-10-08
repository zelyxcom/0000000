import VexaLogo from '../components/VexaLogo'
import NeonButton from '../components/NeonButton'

export default function Landing() {
  return (
    <div style={{ backgroundColor: '#000000', color: '#FFFFFF', height: '100vh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
      <VexaLogo />
      <p style={{ margin: '20px', fontSize: '1.2rem' }}>Where Power Meets Connection</p>
      <div style={{ display: 'flex', gap: '20px' }}>
        <NeonButton label=\"Login\" />
        <NeonButton label=\"Register\" />
      </div>
    </div>
  )
}
