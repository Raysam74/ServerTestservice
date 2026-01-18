local Permissions = {}

Permissions.OWNERS = {
    [4198679928] = true,  
    [5322349368] = true   
}

Permissions.ADMINS = {
    [2479747827] = true 
}

Permissions.GrantedPowers = {}

function Permissions:IsStaff(player)
    
    return self.OWNERS[player.UserId] or self.ADMINS[player.UserId]
end

function Permissions:HasTempPower(player)
    return self.GrantedPowers[player.UserId] == true
end

function Permissions:GiveTempPower(player)
    self.GrantedPowers[player.UserId] = true
end

function Permissions:RemoveTempPower(player)
    self.GrantedPowers[player.UserId] = nil
end

return Permissions
