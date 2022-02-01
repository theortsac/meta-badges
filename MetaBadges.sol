// SPDX-License-Identifier: MIT

pragma solidity 0.8.11;

contract MetaBadges {
    struct Badge {
        uint256 id;
        string name;
        string description;
        uint256 maxSupply;
        uint256 totalSupply;
        address creator;
    }

    event badgeCreated(Badge newBadge);

    mapping(address => uint256[]) addressToBadges;
    mapping(uint256 => Badge) idToBadge;
    mapping(string => uint256) nameToId;

    uint256 currentId = 1;

    function createBadge(
        string calldata _name,
        string calldata _description,
        uint256 _maxSupply
    ) public {
        require(nameToId[_name] == 0);
        require(bytes(_name).length > 0);
        Badge memory newBadge = Badge(
            currentId,
            _name,
            _description,
            _maxSupply,
            0,
            msg.sender
        );
        idToBadge[currentId] = newBadge;
        nameToId[_name] = currentId;
        currentId++;
        emit badgeCreated(newBadge);
    }

    function awardBadge(address _to, uint256 _badgeId) public {
        require(msg.sender == idToBadge[_badgeId].creator);
        if (idToBadge[_badgeId].maxSupply > 0) {
            require(
                idToBadge[_badgeId].totalSupply < idToBadge[_badgeId].maxSupply
            );
        }
        for (uint256 i = 0; i < addressToBadges[_to].length; i++) {
            if (addressToBadges[_to][i] == _badgeId) {
                revert();
            }
        }
        addressToBadges[_to].push(_badgeId);
    }

    function badgesOwned(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        return addressToBadges[_owner];
    }

    function nameToBadge(string calldata _name)
        public
        view
        returns (Badge memory)
    {
        return idToBadge[nameToId[_name]];
    }

    function badgeIdToBadge(uint256 _id) public view returns (Badge memory) {
        return idToBadge[_id];
    }
}
