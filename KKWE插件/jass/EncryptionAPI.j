#ifndef EncryptionAPIIncluded
#define EncryptionAPIIncluded


library EncryptionLibray

globals
//private string OT = "abcdRSTUVefghiponmqr0123stuvyzABCLMNOPQWXYZ456FGHwxK789@#$jlk%&?DE!^*~"
private string OT = "=zDGwsym$fR7DGT33E#TGVFMC^YRLxxT6*t!hdJ^xP%=!!*a^5qNW%Q&S83CRz6Q"
endglobals



   function EncryptionAPI_ChangeKey takes string NeedChange returns nothing
      set OT  = NeedChange
   endfunction



   function getNumberPlace takes string str returns integer
      local integer i = 0
      loop
         exitwhen i == StringLength(OT)
            if(SubString(OT,i,i+1) == str)then
               return i
            endif
         set i = i+1
      endloop
   return i
   endfunction


   function getNumberValue takes integer in returns string
      local integer iny = 0
      local integer otlength = 0
      set iny = in
      set otlength = StringLength(OT)
      if(iny>otlength)then
         set iny = ModuloInteger(iny, otlength)
      endif

      if(iny<0) then
         set  iny = iny + otlength   
      endif
      return SubString(OT,iny,iny+1)	
   endfunction



   function getJSpassword takes string str returns integer
      local integer yw = 0
      local integer t = 0
      local integer valueof = 0
      loop
         exitwhen t == StringLength(str)
         set valueof = S2I(SubString(str,t,t+1))
         if(((t-(t/2))*2) == 0)then
            set yw = yw - valueof
         else
            set yw = yw + valueof
         endif
         set t = t+1
      endloop

      return yw
   endfunction


   function getFistValue takes string str returns string
      local integer i = 0
      local integer leng = 0
      local string codev = "" 
      set leng = StringLength(str)
      loop
         exitwhen i == leng
         set codev = SubString(str,i,i+1)
         if(codev == "l")then
            return SubString(str,0,i)
         endif
      set i = i+1
      endloop   
      return "0"
   endfunction

   function C2P takes string savevalue,string Playername returns string

   local string password = ""
   local integer kest = 0
   local integer randomz = 0
   local string zuisave = ""

   local integer jsPassWordV = 0
   local integer otLength = 0

   local string save_lsv = ""
   local string save_code = ""
   local string save_value = ""
   //循环计算
   local integer u = 0

   set kest = GetRandomInt(0,69)
   set randomz = GetRandomInt(0,9999)
   set password = I2S(IAbsBJ(StringHash(Playername)) - kest)
   set zuisave = password + I2S(randomz) + "l" + savevalue

   set jsPassWordV = getJSpassword(password)
   set otLength = StringLength(OT)


   if(jsPassWordV>=0)then
    
      loop
            exitwhen u == StringLength(zuisave)
         set save_lsv = SubString(zuisave,u,u+1)
         set save_code = save_code + getNumberValue(ModuloInteger((getNumberPlace(save_lsv) + jsPassWordV +u),otLength ))
         set u = u+1
      endloop
      set save_value = save_code + getNumberValue(kest)
   else
      loop
            exitwhen u == StringLength(zuisave)
         set save_lsv = SubString(zuisave,u,u+1)
         set save_code = save_code + getNumberValue(ModuloInteger((getNumberPlace(save_lsv) + jsPassWordV -u),otLength ))
         set u = u+1
      endloop
      set save_value = save_code + getNumberValue(kest)
   endif
//颜色
      return save_value
   endfunction

   function P2C takes string loadvalue,string Playername returns string
      local string keyValue = ""
      local integer kest = 0
      local integer randomZ = 0
      local string loadDS = ""

      local integer jskeyValue = 0
      local integer otLength = 0
      local integer loadLength = 0

      local string load_lsv = ""
      local string codeV = ""
      local string load_code = ""
      local string load_value = ""
      local string load_remove = ""
      //循环计算
      local integer u = 0
      local boolean flag = true

      set loadLength = StringLength(loadvalue)
      set loadDS = SubString(loadvalue,(loadLength-1),loadLength)
      set kest = getNumberPlace(loadDS)
      set keyValue = I2S(IAbsBJ(StringHash(Playername)) - kest)
      set jskeyValue = getJSpassword(keyValue)
      set otLength = StringLength(OT)



      if(jskeyValue>=0)then
         set jskeyValue = -jskeyValue
         set load_lsv = SubString(loadvalue,0,(loadLength-1))
         loop
               exitwhen u == StringLength(load_lsv)
            set codeV = SubString(load_lsv,u,u+1)
            set load_code= load_code + getNumberValue(ModuloInteger((getNumberPlace(codeV) + jskeyValue -u),otLength ))
            set u = u+1
         endloop
      else
         set jskeyValue = -jskeyValue
         set load_lsv = SubString(loadvalue,0,(loadLength-1))
         loop
               exitwhen u == StringLength(load_lsv)
            set codeV = SubString(load_lsv,u,u+1)
            set load_code= load_code + getNumberValue(ModuloInteger((getNumberPlace(codeV) + jskeyValue +u),otLength ))
            set u = u+1
         endloop
      endif

   if(keyValue != SubString(load_code,0,StringLength(keyValue)))then
      set flag = false  
   else
      set load_value = SubString(load_code,StringLength(keyValue),StringLength(load_code))
      set load_remove=getFistValue(load_value)
      set load_value = SubString(load_value,(StringLength(load_remove) + 1),StringLength(load_value))
   endif

   if(flag)then
      return load_value
   else
      return "error"
   endif    
endfunction

endlibrary

#endif//EncryptionAPIIncluded