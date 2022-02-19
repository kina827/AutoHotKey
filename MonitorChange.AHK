getMonitorHandle(hMonitor) {
  VarSetCapacity(Physical_Monitor, 8 + 256, 0)
  DllCall("dxva2\GetPhysicalMonitorsFromHMONITOR", "int", hMonitor, "uint", 1, "int", &Physical_Monitor)
  return hPhysMon := NumGet(Physical_Monitor)
}

destroyMonitorHandle(handle) {
  DllCall("dxva2\DestroyPhysicalMonitor", "int", handle)
}

setMonitorInputSource(source, hMonitor) {
  handle := getMonitorHandle(hMonitor)
  DllCall("dxva2\SetVCPFeature", "int", handle, "char", 0x60, "uint", source)
  destroyMonitorHandle(handle)
}

getMonitorInputSource(hMonitor) {
  handle := getMonitorHandle(hMonitor)
  DllCall("dxva2\GetVCPFeatureAndVCPFeatureReply", "int", handle, "char", 0x60, "Ptr", 0, "uint*", currentValue, "uint*", maximumValue)
  destroyMonitorHandle(handle)
  return currentValue
}

MONITORENUMPROC(hMonitor, hDC, pRECT, data) {
  mInput := getMonitorInputSource(hMonitor)
  if(mInput == 7)
    setMonitorInputSource(5, hMonitor)
  else
    setMonitorInputSource(7, hMonitor)
  return true
}

switchAllMonitor(){
  Callback_Func := RegisterCallback("MONITORENUMPROC")
  DllCall("EnumDisplayMonitors", Ptr, 0, Ptr, 0, Ptr, Callback_Func, Ptr, 0)
}

F19::
switchAllMonitor()
return