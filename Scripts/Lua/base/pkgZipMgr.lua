doNameSpace("pkgZipMgr")

function unzip( strZipFileName, strOutputPath, progressCb, completeCb, errorCb, dWriteBufferSize )

	-- 压缩文件太小的话，GetTotalSize接口会返回0
	local dTotal = KG.CustomZip.GetTotalSize(strZipFileName)
	if dTotal <= 0 then
		return
	end

	local function unzipCallback(dCurrent)
		
		if progressCb then
			progressCb(dCurrent, dTotal)
		end

		if dCurrent >= dTotal then
			completeCb()
		end
	end

	local function errorCallback(strMessage)
		if errorCb then
			errorCb(strMessage)
		end
	end
	
	dWriteBufferSize = dWriteBufferSize or 1024*50
	KG.CustomZip.Unzip(strZipFileName, strOutputPath, unzipCallback, errorCallback, dWriteBufferSize)
end